//
//  CityListView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Core
import CoreUI

struct CityListView: View {
    @EnvironmentObject private var router: MapFeatureRouter
    @StateObject private var viewModel: CityListView.ViewModel = .init(cityRepository: .init())
    
    @State private var searchText = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var subject = PassthroughSubject<String, Never>()
    
    var body: some View {
        
        NavigationStack(path: $router.navigationPath) {
            contentView
                .navigationTitle(viewModel.state.navigationTitle)
                .navigationDestination(for: MapFeatureRouter.Destination.self) { destination in
                    router.viewFor(for: destination)
                        .environmentObject(router)
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
        }
        .task {
            await viewModel.send(.onLoad)
        }
    }
}

private extension CityListView {
    @ViewBuilder
    var contentView: some View {
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
    
    func listView(_ cities: [City]) -> some View {
        List(cities) { city in
            CoreUI.RowView(
                title: city.displayTitle,
                subtitle: "\(city.coord.lat), \(city.coord.lon)"
            ) {
                router.push(screen: .mapView(city))
            }
        }
    }
}
