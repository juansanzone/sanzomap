//
//  MapFeature+MainView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import CoreUI

public extension MapFeature {
    struct MainView: View {
        @StateObject private var router: MapFeatureRouter = .init()
        
        public init() {}
        
        public var body: some View {
            CityListView()
                .environmentObject(router)
        }
    }
}
