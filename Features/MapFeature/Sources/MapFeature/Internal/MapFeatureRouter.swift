//
//  MapFeatureRouter.swift
//  MapFeature
//
//  Created by Juan Sanzone on 12/03/2025.
//

import Core
import CoreUI

final class MapFeatureRouter: Core.Architecture.NavigationRouter {
    @Published var navigationPath = NavigationPath()
    
    var isPresentingScreen: Bool = false
    var presentingDestination: Destination?
    var willChangeNavigationPathCallback: (() -> Void)?
}

extension MapFeatureRouter {
    enum Destination: Hashable {
        case mapView(City)
    }
}

extension MapFeatureRouter {
    @ViewBuilder
    func viewFor(for destination: MapFeatureRouter.Destination) -> some View {
        switch destination {
        case let .mapView(selectedCity):
            MapCityView(city: selectedCity)
        }
    }
}
