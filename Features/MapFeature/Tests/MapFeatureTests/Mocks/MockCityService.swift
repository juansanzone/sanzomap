//
//  MockCityService.swift
//  Services
//
//  Created by Juan Sanzone on 11/03/2025.
//

@testable import Services

public typealias MockCity = Services.CityService.CityDTO

public final class MockCityService: Services.CityServiceProtocol {
    var citiesToReturn: [MockCity] = []
    var errorToThrow: Error?

    public func fetchCities() async throws -> [MockCity] {
        if let error = errorToThrow {
            throw error
        }
        return citiesToReturn
    }
}
