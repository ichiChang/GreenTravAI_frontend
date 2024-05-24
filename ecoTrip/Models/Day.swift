//
//  Day.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct Day: Identifiable, Codable, Hashable {
    var id: Int
    var date: String
    var travelPlanId: Int
}

