//
//  CityListView+ViewModel.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Core
import Combine
import Services
import SwiftUI

extension CityListView {
    final class ViewModel: Core.Architecture.ObservableViewModel {
        @Published var state: State
        private let cityRepository: CityRepository
        private var cancellables = Set<AnyCancellable>()
        
        /// View state source of truth
        struct State: Core.Architecture.KeyPathMutable, Equatable {
            let navigationTitle: String = "Cities"
            let searchBarTitle: String = "Search cities"
            var cities: Core.Foundation.DataState<[City]> = .loading
        }
        
        /// View Actions
        enum Action: Equatable {
            case onAppear
            case search(String)
            case retry
        }
        
        init(state: State = .init(), cityRepository: CityRepository) {
            self.state = state
            self.cityRepository = cityRepository
            bindRepositoryChanges()
        }
    }
}

/// Process UI Actions
extension CityListView.ViewModel {
    func send(_ action: Action) async {
        switch action {
        case .onAppear:
            await loadInitialData()
        case .search(let searchTerm):
            await cityRepository.searchCities(with: searchTerm)
        case .retry:
            /// Just call to `loadInitialData` for this exercice.
            /// But we can decide as a team how to manage retry behaivoir better.
            await loadInitialData()
        }
    }
}

private extension CityListView.ViewModel {
    func bindRepositoryChanges() {
        cityRepository.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedCities in
                guard let self else { return }
                self.state = self.state.modifying(\.cities, to: .loaded(updatedCities))
            }
            .store(in: &cancellables)
     }
    
    func loadInitialData() async {
        do {
            state = state.modifying(\.cities, to: .loading)
            try await cityRepository.loadInitialData()
        } catch {
            state = state.modifying(\.cities, to: .error(error))
        }
    }
}
