//
//  MapFeatureView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Core
import CoreUI

struct MapFeatureView: View {
    @StateObject private var viewModel: MapFeatureView.ViewModel = .init(cityRepository: .init())
    
    @State private var searchText = ""
    @State private var cancellables = Set<AnyCancellable>()
    
    private let subject = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle(viewModel.state.navigationTitle)
        }
        .searchable(text: $searchText, prompt: viewModel.state.searchBarTitle)
        .onChange(of: searchText) { _, newValue in
            subject.send(newValue)
        }
        .onAppear {
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
            await viewModel.send(.onAppear)
        }
    }
}

private extension MapFeatureView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state.cities {
        case .loading:
            skeletonView
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
    
    var skeletonView: some View {
        List {
            ForEach(0..<5, id: \.self) { _ in
                CoreUI.RowView(
                    title: "Some title...",
                    subtitle: "Some subtitle"
               )
            }
        }
        .redacted(reason: .placeholder)
    }
    
    func listView(_ cities: [City]) -> some View {
        List(cities) { city in
            CoreUI.RowView(
                title: city.displayTitle,
                subtitle: "\(city.coord.lat), \(city.coord.lon)"
            )
        }
    }
}
