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
                .disabled(viewModel.state.isFirstTimeLoading)
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
        .overlay {
            initialLoadingProgresView
        }
    }
    
    var landscapeView: some View {
        HStack(spacing: .Space.zero) {
            mainView
            MapCityView(city: viewModel.state.selectedCity)
        }
        .disabled(viewModel.state.isFirstTimeLoading)
        .ignoresSafeArea()
        .overlay {
            initialLoadingProgresView
        }
    }
    
    @ViewBuilder
    var contentListView: some View {
        switch viewModel.state.cities {
        case .loading:
            CoreUI.SkeletonListView()
        case let .loaded(cities):
            if cities.isEmpty {
                emptyStateView
            } else {
                listView(cities)
            }
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
    
    var emptyStateView: some View {
        VStack(spacing: .Space.large) {
            Text("No cities were found matching that criteria.")
                .multilineTextAlignment(.center)
                .fontDesign(.rounded)
                .font(.callout)
                .fontWeight(.semibold)
                .fullWidth(alignment: .center)
                .padding(.horizontal)
            if viewModel.state.isShowingOnlyFavorites {
                VStack(spacing: .Space.xSmall) {
                    Text("The favorites filter is applied.\nDo you want to turn off?")
                        .multilineTextAlignment(.center)
                        .fontDesign(.rounded)
                        .font(.callout)
                        .fontWeight(.light)
                        .fullWidth(alignment: .center)
                        .padding(.horizontal)
                    Button("Turn off") {
                        Task {
                            await viewModel.send(.toggleFavoritesFilter)
                        }
                    }
                    .tint(.pink)
                }
            }
        }
    }
    
    func listView(_ cities: [City]) -> some View {
        List(cities) { city in
            CityRowView(
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
    
    @ViewBuilder
    var initialLoadingProgresView: some View {
        if viewModel.state.isFirstTimeLoading {
            VStack(spacing: .Space.small) {
                Spacer()
                Text("Fetching and indexing data...")
                    .font(.title2)
                    .fontDesign(.rounded)
                    .fontWeight(.light)
                    .fullWidth(alignment: .center)
                Text("\(viewModel.state.firstTimeLoadingProgress) %")
                    .font(.title2)
                    .monospaced()
                    .fontDesign(.rounded)
                    .fullWidth(alignment: .center)
                ProgressView(value: CGFloat(viewModel.state.firstTimeLoadingProgress), total: 100)
                    .tint(.pink)
                    .padding(.horizontal, .Space.xLarge)
                Spacer()
                Text("Be patient.. This will only happen the first time you run the application.")
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                    .font(.callout)
                    .fontWeight(.light)
                    .fullWidth(alignment: .center)
                    .padding(.bottom, .Space.xLarge * 2)
                    .padding(.horizontal)
            }
            .ignoresSafeArea()
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .cornerRadius(20)
        } else {
            EmptyView()
        }
    }
}
