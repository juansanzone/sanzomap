//
//  MainView.swift
//  SanzoMap
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI
import Services

struct MainView: View {
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

/// This is temporary basic ui. Just for test.
private extension MainView {
    var listView: some View {
        List(cities) { city in
            rowView(
                title: city.displayName,
                subtitle: "\(city.coord.lat), \(city.coord.lon)"
            )
        }
    }
    
    @ViewBuilder
    func rowView(title: String, subtitle: String) -> some View {
        HStack {
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary.opacity(0.8))
                    .fullWidth()
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .fullWidth()
                }
            }
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
        }
    }
}

extension View {
    @ViewBuilder
    func fullWidth(alignment: Alignment = .leading) -> some View {
        self.modifier(FullWidthModifier(alignment: alignment))
    }
}


fileprivate struct FullWidthModifier: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
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
