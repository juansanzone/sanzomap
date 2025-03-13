//
//  CityListView+ViewModel.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Core
import Services
import SwiftUI

extension CityListView {
    final class ViewModel: Core.Architecture.ObservableViewModel {
        @Published var state: State
        var router: MapFeatureRouter
        
        private let cityRepository: CityRepository
        private var cancellables = Set<AnyCancellable>()
        
        /// View state source of truth
        struct State: Core.Architecture.KeyPathMutable, Equatable {
            let navigationTitle: String = "Cities"
            let searchBarTitle: String = "Search cities"
            var selectedCity: City = .defaultCity
            var cities: Core.Foundation.DataState<[City]> = .loading
            var screenOrientation: UIDeviceOrientation
            
            var isLandscape: Bool {
                screenOrientation == .landscapeLeft || screenOrientation == .landscapeRight
            }
        }
        
        /// View Actions
        enum Action: Equatable {
            case onAppear
            case search(String)
            case retry
            case selectCity(City)
        }
        
        init(
            state: State = .init(screenOrientation: UIDevice.current.orientation),
            cityRepository: CityRepository,
            router: MapFeatureRouter
        ) {
            self.state = state
            self.cityRepository = cityRepository
            self.router = router
            bindRepositoryChanges()
            bindDeviceOrientationChanges()
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
        case let .selectCity(selectedCity):
            state = state.modifying(\.selectedCity, to: selectedCity)
            if !state.isLandscape {
                router.push(screen: .mapView(selectedCity))
            }
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
    
    func bindDeviceOrientationChanges() {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self,
                      let device = notification.object as? UIDevice else { return }
                self.state = self.state.modifying(\.screenOrientation, to: device.orientation)
                if state.isLandscape {
                    router.popToRoot()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadInitialData() async {
        do {
            if cityRepository.searchResults.isEmpty {
                state = state.modifying(\.cities, to: .loading)
            }
            try await cityRepository.loadInitialData()
        } catch {
            state = state.modifying(\.cities, to: .error(error))
        }
    }
}
