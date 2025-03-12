//
//  MapFeature+MainView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import CoreUI

public extension MapFeature {
    struct MainView: View {
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        @StateObject private var router: MapFeatureRouter = .init()
        @State private var landscapeModeSelectedCity: City = .defaultPoint
        
        public init() {}
        
        public var body: some View {
            switch verticalSizeClass {
            case .regular:
                portraitView
            case .compact:
                landscapeView
            default:
                portraitView
            }
        }
    }
}

private extension MapFeature.MainView {
    var portraitView: some View {
        CityListView()
            .environmentObject(router)
    }
    
    var landscapeView: some View {
        HStack(spacing: 0) {
            CityListView() { selectedCity in
                landscapeModeSelectedCity = selectedCity
            }
            .environmentObject(router)
            MapCityView(city: landscapeModeSelectedCity)
        }.ignoresSafeArea()
    }
}
