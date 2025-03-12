//
//  City.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Services

struct City: Identifiable {
    let id: Int
    let name: String
    let country: String
    let coord: City.Coord
    
    init(dto: Services.CityService.CityDTO) {
        id = dto._id
        name = dto.name.lowercased()
        country = dto.country
        coord = dto.coord
    }
}

extension City {
    typealias Coord = Services.CityService.CityDTO.CoordinatesDTO
    
    var displayTitle: String {
        "\(name.capitalized), \(country.uppercased())"
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}

extension City: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
