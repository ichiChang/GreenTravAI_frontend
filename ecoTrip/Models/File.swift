//
//  File.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/5/26.
//

import Foundation

struct Message: Identifiable {
    let id: UUID
    var content: String
    var isCurrentUser: Bool
    var recommendations: [Recommendation] = []
    
    init(id: UUID = UUID(), content: String, isCurrentUser: Bool, recommendations: [Recommendation] = []) {
        self.id = id
        self.content = content
        self.isCurrentUser = isCurrentUser
        self.recommendations = recommendations
    }
}
struct DataSource {
    static let messages: [Message] = []
}

