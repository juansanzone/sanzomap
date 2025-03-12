import XCTest
@testable import Services
@testable import MapFeature

@MainActor
final class CityRepositoryTests: XCTestCase {
    func test_loadInitialData_success_shouldPopulateSearchResults() async throws {
        let mockService = MockCityService()
        let sampleCities = [
            MockCity(_id: 1, name: "City A", country: "CA", coord: .init(lat: 100, lon: 100)),
            MockCity(_id: 2, name: "City B", country: "CB", coord: .init(lat: 100, lon: 100))
        ]
        mockService.citiesToReturn = sampleCities
        
        let repository = CityRepository(cityService: mockService, maxResults: 50)
        
        try await repository.loadInitialData()
        
        XCTAssertEqual(repository.searchResults.count, sampleCities.count, "Should have same count as sample cities")
        XCTAssertEqual(repository.searchResults[0].displayTitle, "City A, CA")
        XCTAssertEqual(repository.searchResults[1].displayTitle, "City B, CB")
    }
    
    func test_maxResults_shouldLimitSearchResults() async throws {
        let mockService = MockCityService()
        let sampleCities = [
            MockCity(_id: 1, name: "CityA", country: "CountryA", coord: .init(lat: 100, lon: 100)),
            MockCity(_id: 2, name: "CityB", country: "CountryB", coord: .init(lat: 100, lon: 100))
        ]
        mockService.citiesToReturn = sampleCities
        
        let repository = CityRepository(cityService: mockService, maxResults: 1)
        try await repository.loadInitialData()
        
        XCTAssertEqual(repository.searchResults.count, 1, "Should only return one city due to maxResults limit")
    }
    
    func test_loadInitialData_failure_shouldThrowError() async throws {
        let mockService = MockCityService()
        let sampleError = NSError(domain: "Test", code: 1, userInfo: nil)
        mockService.errorToThrow = sampleError
        
        let repository = CityRepository(cityService: mockService, maxResults: 50)
        
        do {
            try await repository.loadInitialData()
            XCTFail("Expected an error but loadInitialData succeeded")
        } catch {
            XCTAssertEqual((error as NSError).domain, sampleError.domain, "Should throw the correct error")
        }
    }
    
    func test_searchCities_shouldFilterCitiesProperly() async throws {
        let mockService = MockCityService()
        let sampleCities = [
            MockCity(_id: 1, name: "New York", country: "USA", coord: .init(lat: 100, lon: 100)),
            MockCity(_id: 2, name: "Newark", country: "USA", coord: .init(lat: 200, lon: 200)),
            MockCity(_id: 3, name: "Boston", country: "USA", coord: .init(lat: 300, lon: 300))
        ]
        mockService.citiesToReturn = sampleCities
        let repository = CityRepository(cityService: mockService, maxResults: 50)
        
        try await repository.loadInitialData()
        
        repository.searchCities(with: "new")
        
        XCTAssertEqual(repository.searchResults.count, 2, "Should filter and return 2 cities")
        XCTAssertTrue(
            repository.searchResults.allSatisfy { $0.name.lowercased().hasPrefix("new") },
            "All returned cities should have names starting with 'new'"
        )
    }
    
    func test_searchCities_forInvalidSearchTerm_shouldReturnZeroCities() async throws {
        let mockService = MockCityService()
        let sampleCities = [
            MockCity(_id: 1, name: "New York", country: "USA", coord: .init(lat: 100, lon: 100)),
            MockCity(_id: 2, name: "Newark", country: "USA", coord: .init(lat: 200, lon: 200)),
            MockCity(_id: 3, name: "Boston", country: "USA", coord: .init(lat: 300, lon: 300))
        ]
        mockService.citiesToReturn = sampleCities
        let repository = CityRepository(cityService: mockService, maxResults: 50)
        
        try await repository.loadInitialData()
        
        repository.searchCities(with: "888494")
        
        XCTAssertEqual(repository.searchResults.count, 0, "Should filter and return 0 cities")
    }
    
    func test_searchCities_withPrefix_asDocumentCriteria_shouldReturnExpectedCities() async throws {
        let mockService = MockCityService()
        let sampleCities = [
          MockCity(_id: 1, name: "Alabama", country: "US", coord: .init(lat: 0, lon: 0)),
          MockCity(_id: 2, name: "Albuquerque", country: "US", coord: .init(lat: 0, lon: 0)),
          MockCity(_id: 3, name: "Anaheim", country: "US", coord: .init(lat: 0, lon: 0)),
          MockCity(_id: 4, name: "Arizona", country: "US", coord: .init(lat: 0, lon: 0)),
          MockCity(_id: 5, name: "Sydney", country: "AU", coord: .init(lat: 0, lon: 0))
        ]
        mockService.citiesToReturn = sampleCities
        let repository = CityRepository(cityService: mockService, maxResults: 50)

        try await repository.loadInitialData()

        repository.searchCities(with: "A")
        XCTAssertEqual(repository.searchResults.count, 4, "Prefix 'A' should return 4 cities")

        repository.searchCities(with: "s")
        XCTAssertEqual(repository.searchResults.count, 1, "Prefix 's' should return 1 city")
        XCTAssertEqual(repository.searchResults.first?.displayTitle, "Sydney, AU")

        repository.searchCities(with: "Al")
        XCTAssertEqual(repository.searchResults.count, 2, "Prefix 'Al' should return 2 cities")
        let alCities = repository.searchResults.map { $0.displayTitle }
        XCTAssertTrue(alCities.contains("Alabama, US"))
        XCTAssertTrue(alCities.contains("Albuquerque, US"))

        repository.searchCities(with: "Alb")
        XCTAssertEqual(repository.searchResults.count, 1, "Prefix 'Alb' should return 1 city")
        XCTAssertEqual(repository.searchResults.first?.displayTitle, "Albuquerque, US")
    }
}
