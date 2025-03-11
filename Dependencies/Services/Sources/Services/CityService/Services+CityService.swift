//
//  Services+CityService.swift
//  Services
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Core

public extension Services {
    struct CityService {
        private let networkService: Core.Networking.NetworkServicing
        
        /// We are using empty custom`headers` and `parameters`for that Service. But we could add if needed.
        /// Also we are able to override the `basePath` url param  and `cachePolicy` if needed.
        let fetchCitiesRequest = Core.Networking.APIRequest(
            path: "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json",
            method: .get,
            headers: [:],
            parameters: [:]
        )
        
        public init(
            networkService: Core.Networking.NetworkServicing = Core.Networking.NetworkService()
        ) {
            self.networkService = networkService
        }
    }
}

public extension Services.CityService {
    func fetchCities() async throws -> [Services.CityService.CityDTO] {
        try await networkService.fetch(request: fetchCitiesRequest) as [Services.CityService.CityDTO]
    }
}
