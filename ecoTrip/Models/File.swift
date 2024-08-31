//
//  File.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/5/26.
//

import Foundation

struct Message: Hashable {
    var id = UUID()
    var content: String
    var isCurrentUser: Bool
}

struct DataSource {
    static let messages: [Message] = []
}

