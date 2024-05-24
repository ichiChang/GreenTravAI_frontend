//
//  Stop.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/17.
//

import Foundation

struct Stop: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var startTime: String
    var endTime: String
    var note: String?
    var placeId: Int
    var dayId: Int
}

