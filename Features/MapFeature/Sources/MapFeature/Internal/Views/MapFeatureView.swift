//
//  MapFeatureView.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import CoreUI
import Services

struct MapFeatureView: View {
    /// This is temporary. Just to test the packages integration.
    private let service: Services.CityService = .init()
    @State private var cities: [Services.CityService.CityDTO] = .init()
    
    var body: some View {
        NavigationView {
            listView
                .navigationTitle("Cities")
        }
        .redacted(reason: cities.isEmpty ? .placeholder : [])
        .task {
            do {
                cities = try await service.fetchCities()
            } catch {
                // TODO: Error state.
            }
        }
    }
}

/// This is temporary. Just to test the packages integration.
private extension MapFeatureView {
    var listView: some View {
        List(cities) { city in
            CoreUI.rowView(
                title: city.displayName,
                subtitle: "\(city.coord.lat), \(city.coord.lon)"
            )
        }
    }
}

/// This is temporary basic ui. Just for test.
/// I will use the proper display object once the repository is implemented.
typealias City = Services.CityService.CityDTO
extension City: @retroactive Identifiable {
    public var id: Int {
        _id
    }
    
    var displayName: String {
        "\(name.capitalized), \(country.uppercased())"
    }
}
