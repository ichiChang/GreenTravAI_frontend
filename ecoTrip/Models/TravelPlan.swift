//
//  TravelPlan.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Foundation

struct TravelPlan: Identifiable, Codable, Hashable {
    let id: String
    let createdAt: String
    let enddate: String
    let planname: String
    let startdate: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case enddate
        case planname
        case startdate
    }
    
    var createdAtDate: Date? {
        dateFormatter.date(from: createdAt)
    }
    
    var enddateDate: Date? {
        dateFormatter.date(from: enddate)
    }
    
    var startdateDate: Date? {
        dateFormatter.date(from: startdate)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}


