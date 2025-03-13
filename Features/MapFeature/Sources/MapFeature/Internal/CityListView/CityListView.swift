//
//  CityListView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Core
import CoreUI

struct CityListView: View {
    @StateObject private var viewModel: CityListView.ViewModel
    
    @State private var searchText = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var subject = PassthroughSubject<String, Never>()
    
    init(router: MapFeatureRouter) {
        _viewModel = StateObject(wrappedValue: .init(cityRepository: .init(), router: router))
    }
    
    var body: some View {
        if viewModel.state.isLandscape {
            landscapeView
        } else {
            mainView
        }
    }
}

private extension CityListView {
    var mainView: some View {
        NavigationStack(path: $viewModel.router.navigationPath) {
            contentListView
                .navigationTitle(viewModel.state.navigationTitle)
                .navigationDestination(for: MapFeatureRouter.Destination.self) { destination in
                    viewModel.router.viewFor(for: destination)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        favFilterButtonView
                    }
                }
        }
        .searchable(text: $searchText, prompt: viewModel.state.searchBarTitle)
        .onChange(of: searchText) { _, newValue in
            subject.send(newValue)
        }
        .onAppear {
            Task {
                await viewModel.send(.onAppear)
            }
            subject
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                .sink { newValue in
                    Task {
                        await viewModel.send(.search(newValue))
                    }
                }
                .store(in: &cancellables)
            Task {
                await viewModel.send(.search(searchText))
            }
        }
    }
    
    var landscapeView: some View {
        HStack(spacing: .Space.zero) {
            mainView
            MapCityView(city: viewModel.state.selectedCity)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    var contentListView: some View {
        switch viewModel.state.cities {
        case .loading:
            CoreUI.SkeletonListView()
        case let .loaded(cities):
            listView(cities)
        case let .error(error):
            CoreUI.ErrorView(error: error) {
                Task {
                    await viewModel.send(.retry)
                }
            }
        }
    }
    
    var favFilterButtonView: some View {
        Button {
            Task {
                await viewModel.send(.toggleFavoritesFilter)
            }
        } label: {
            Image(systemName: viewModel.state.isShowingOnlyFavorites ? "star.fill" : "star")
        }
        .tint(.yellow)
    }
    
    func listView(_ cities: [City]) -> some View {
        List(cities) { city in
            CoreUI.RowView(
                title: city.displayTitle,
                subtitle: "\(city.coord.lat), \(city.coord.lon)",
                isFav: city.isFavorite,
                onFavToggle: { isFavorite in
                    Task {
                        await viewModel.send(.updateCity(city: city, isFav: isFavorite))
                    }
                }
            ) {
                Task {
                    await viewModel.send(.selectCity(city))
                }
            }
        }
    }
}
