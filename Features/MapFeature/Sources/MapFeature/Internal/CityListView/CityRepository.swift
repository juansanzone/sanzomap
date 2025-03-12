//
//  CityRepository.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Services

@MainActor
final class CityRepository: ObservableObject {
    @Published var searchResults: [City] = []
    
    private var cities: [City] = .init()
    private let service: Services.CityServiceProtocol
    private let maxResults: Int
    
    init(
        cityService: Services.CityServiceProtocol = Services.CityService(),
        maxResults: Int = 50
    ) {
        service = cityService
        self.maxResults = maxResults
    }
    
    func loadInitialData() async throws {
        guard cities.isEmpty else { return }
        do {
            cities = try await service.fetchCities().map( { City(dto: $0) })
            searchResults = sortAndLimit(cities)
        } catch {
            throw error
        }
    }
    
    func searchCities(with searchTerm: String) {
        guard !searchTerm.isEmpty else {
            searchResults = sortAndLimit(cities)
            return
        }
        let searchTerm = searchTerm.lowercased()
        let filteredCities = cities.filter {
            $0.name.lowercased().hasPrefix(searchTerm)
        }
        searchResults = sortAndLimit(filteredCities)
    }
}

private extension CityRepository {
    private func sortAndLimit(_ cities: [City]) -> [City] {
         return Array(cities.sorted {
             ($0.name, $0.country) < ($1.name, $1.country)
         }.prefix(maxResults))
     }
}
