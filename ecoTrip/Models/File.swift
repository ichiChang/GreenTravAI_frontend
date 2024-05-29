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
    
    static let messages = [
        Message(content: "Hi ! 我今天可以如何協助你？", isCurrentUser: false),
        
        Message(content: "可以幫我規劃台南三天兩夜行程嗎", isCurrentUser: true),
        
        Message(content: "當然可以！來幫你規劃一個充實的台南三天兩夜行程吧。\n第一天：赤崁樓\n第二天：奇美博物館\n第三天：神農街\n希望這個行程能讓你在台南有個美好的三天！如果有任何特別的地方想去或者是食物過敏等情況，都可以告訴我，我可以再進行調整。", isCurrentUser: false),
        Message(content: "我不想去神農街", isCurrentUser: true),
        Message(content: "沒問題，我們可以修改第三天的行程，改去其他有趣的地方。下面是為你調整後的行程：台南市立美術館", isCurrentUser: false)
      
    ]
}
