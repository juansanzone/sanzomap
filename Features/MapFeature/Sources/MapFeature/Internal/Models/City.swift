//
//  City.swift
//  MapFeature
//
//  Created by Juan Sanzone on 11/03/2025.
//

import Services
import SwiftData

@Model
final class City: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var country: String
    var coord: City.Coord
    var isFavorite: Bool
    
    init(dto: Services.CityService.CityDTO) {
        id = dto._id
        name = dto.name.lowercased()
        country = dto.country
        coord = dto.coord
        isFavorite = false
    }
    
    init(_ id: Int, name: String, country: String, coord: Coord, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.country = country
        self.coord = coord
        self.isFavorite = isFavorite
    }
}

extension City {
    typealias Coord = Services.CityService.CityDTO.CoordinatesDTO
    
    var displayTitle: String {
        "\(name.capitalized), \(country.uppercased())"
    }
    
    static var defaultCity: Self {
        City(0, name: "Cupertino", country: "US", coord: .init(lat: 37.322998, lon: -122.032182)) as! Self
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
