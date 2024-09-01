//
//  File.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/5/26.
//

import Foundation

struct Message: Hashable, Identifiable {
    let id: UUID
    var content: String
    var isCurrentUser: Bool
    
    init(id: UUID = UUID(), content: String, isCurrentUser: Bool) {
        self.id = id
        self.content = content
        self.isCurrentUser = isCurrentUser
    }
}
struct DataSource {
    static let messages: [Message] = []
}

