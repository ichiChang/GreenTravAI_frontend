//
//  Stop.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/17.
//

import Foundation
struct Stop: Codable, Identifiable {
    let id: String
    let Address: String
    let stopname: String
    let StartTime: String
    let EndTime: String
    let Note: String?
    let transportationToNext: Transportation?
}

