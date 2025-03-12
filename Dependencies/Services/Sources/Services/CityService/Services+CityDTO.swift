//
//  Services+CityDTO.swift
//  Services
//
//  Created by Juan Sanzone on 10/03/2025.
//

import Core

public extension Services.CityService {
    struct CityDTO: Codable {
        public let _id: Int
        public let name: String
        public let country: String
        public let coord: CityDTO.CoordinatesDTO
        
        public struct CoordinatesDTO: Codable {
            public let lat: Double
            public let lon: Double
            
            public init(lat: Double, lon: Double) {
                self.lat = lat
                self.lon = lon
            }
        }
    }
}
