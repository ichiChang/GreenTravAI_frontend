//
//  Place.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct Place: Codable, Identifiable, Hashable {
    var id: String {
        return _id["$oid"] ?? UUID().uuidString
    }
    var address: String
    var image: String
    var lat: String
    var long: String
    var lowCarbon: Bool
    var openingTime: String
    var placename: String
    var rating: Float
    
    private var _id: [String: String]

    enum CodingKeys: String, CodingKey {
        case _id, address, image, lat, long, lowCarbon, openingTime, placename , rating
    }
}


