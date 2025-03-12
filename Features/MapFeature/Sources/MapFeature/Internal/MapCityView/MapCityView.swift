//
//  MapCityView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 12/03/2025.
//

import CoreUI
import MapKit

struct MapCityView: View {
    private let city: City
    private let region: MKCoordinateRegion
    
    init(city: City) {
        self.city = city
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
    }
    
    var body: some View {
        contentView
            .ignoresSafeArea(edges: .bottom)
    }
}

private extension MapCityView {
    var contentView: some View {
        mapView
            .overlay {
                titleView
                    .padding(.Space.medium)
            }
    }
    
    var titleView: some View {
        VStack {
            CoreUI.PillView(title: city.displayTitle)
            Spacer()
        }
    }
    
    var mapView: some View {
        Map(coordinateRegion: .constant(region), annotationItems: [city]) { city in
            MapMarker(
                coordinate: CLLocationCoordinate2D(
                    latitude: city.coord.lat,
                    longitude: city.coord.lon
                ),
                tint: .pink
            )
        }
    }
}
