//
//  Transportation.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct Transportation: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var timeSpent: Int
    var lowCarbon: Bool
    var createAt: String
    var fromStopId: Int
    var toStopId: Int
}

