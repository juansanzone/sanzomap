//
//  CityRepository.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftData
import Services

@MainActor
final class CityRepository: ObservableObject {
    @Published var searchResults: [City] = []
    @Published var showOnlyFavorites: Bool = false {
        didSet {
            searchCities(with: currentSearchTerm)
        }
    }
    @Published var isFirstTimeLoading: Bool = false
    @Published var initialLoadProgress: Int = 0
    
    private let service: Services.CityServiceProtocol
    private let maxResults: Int
    private var currentSearchTerm: String = ""
    
    private let modelContext: ModelContext
    private let modelContainer: ModelContainer
    
    init(
        modelContext: ModelContext? = nil,
        cityService: Services.CityServiceProtocol = Services.CityService(),
        maxResults: Int = 50
    ) {
        self.service = cityService
        self.maxResults = maxResults
        if let modelContext = modelContext {
            self.modelContext = modelContext
            self.modelContainer = self.modelContext.container
        } else {
            do {
                self.modelContainer = try ModelContainer(for: City.self)
                self.modelContext = modelContainer.mainContext
            } catch {
                Core.Logger.fatal("Failed to create model container: \(error)")
            }
        }
    }
    
    func loadInitialData() async throws {
        let descriptor = FetchDescriptor<City>()
        let existingCount = try modelContext.fetchCount(descriptor)
        guard existingCount == 0 else {
            Core.Logger.debug("Local data found. Loaded from disk 💾..")
            searchResults = try fetchAllSortedAndLimited()
            Core.Logger.debug("Local data loaded successfuly ✅")
            return
        }
        
        await MainActor.run {
            isFirstTimeLoading = true
            initialLoadProgress = 0
        }
        
        do {
            Core.Logger.debug("No saved data. Fetching from network 🛜..")
            await MainActor.run {
                initialLoadProgress = 1
            }
            let cityDTOs = try await service.fetchCities()
            await MainActor.run {
                initialLoadProgress = 2
            }
            let cities = cityDTOs.map { City(dto: $0) }
            
            Core.Logger.debug("Fetch from network finished ✅.. [\(cities.count)] results found.")
            Core.Logger.debug("Saving fetched data  💾")
            
            let totalCount = cities.count
            for (index, city) in cities.enumerated() {
                modelContext.insert(city)
                await MainActor.run {
                    initialLoadProgress = 2 + (index + 1) * 98 / totalCount
                }
            }
            
            try modelContext.save()
            
            Core.Logger.debug("All data is saved and fetched  💾")
            searchResults = sortAndLimit(cities)
            
            isFirstTimeLoading = false
            await MainActor.run {
                initialLoadProgress = 100
            }
        } catch {
            throw error
        }
    }
    
    func searchCities(with searchTerm: String) {
        if isFirstTimeLoading {
            return
        }
        let searchTerm = searchTerm.lowercased()
        currentSearchTerm = searchTerm
        do {
            var predicate: Predicate<City>?
            
            if !searchTerm.isEmpty || showOnlyFavorites {
                predicate = #Predicate<City> { city in
                    (searchTerm.isEmpty ? true : city.name.starts(with: searchTerm)) && (showOnlyFavorites ? city.isFavorite : true)
                }
            }
            
            if predicate == nil {
                searchResults = try fetchAllSortedAndLimited()
            } else {
                var descriptor = FetchDescriptor<City>(
                    predicate: predicate,
                    sortBy: [
                        SortDescriptor(\.name),
                        SortDescriptor(\.country)
                    ]
                )
                descriptor.fetchLimit = maxResults
                searchResults = try modelContext.fetch(descriptor)
            }
        } catch {
            Core.Logger.error(error, message: "Search fail")
            searchResults = []
        }
    }
    
    func updateCity(_ city: City, isFavorite: Bool) {
        do {
            city.isFavorite = isFavorite
            try modelContext.save()
            Core.Logger.debug("Update City fav status: \(isFavorite)")
            searchCities(with: currentSearchTerm)
        } catch {
            Core.Logger.error(error, message: "Failed to update city fav status")
        }
    }
}

private extension CityRepository {
    func fetchAllSortedAndLimited() throws -> [City] {
        var descriptor = FetchDescriptor<City>(
            sortBy: [
                SortDescriptor(\.name),
                SortDescriptor(\.country)
            ]
        )
        descriptor.fetchLimit = maxResults
        return try modelContext.fetch(descriptor)
    }
    
    func sortAndLimit(_ cities: [City]) -> [City] {
        return Array(cities.sorted {
            ($0.name, $0.country) < ($1.name, $1.country)
        }.prefix(maxResults))
    }
}
