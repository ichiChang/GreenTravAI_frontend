//
//  TravelPlan.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct TravelPlan: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var startDay: String
    var endDay: String
    var createAt: String
    var userId: Int
}


