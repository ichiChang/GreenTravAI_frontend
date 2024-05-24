//
//  Place.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct Place: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var openingTime: String?
    var address: String
    var long: String
    var lat: String
    var rating: Float
    var lowCarbon: Bool
}

