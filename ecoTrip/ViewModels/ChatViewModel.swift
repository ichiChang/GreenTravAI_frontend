//
//  ChatViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/25.
//

import Foundation
import Combine

struct MultiDayPlan: Codable {
    var startdate: String
    var enddate: String
    var planname: String
    let Plans: [Plan]
}

struct Plan: Codable {
    let Recommendation: [Recommendation]
}

struct Recommendation: Codable {
    let Activity: String
    let Address: String
    let Location: String
    let description: String
    let latency: String
}

// 同時支援兩種格式
struct PlanRecommendation: Codable {
    let Recommendation_Spot: [Recommendation]?
    let Recommendation: [Recommendation]?
}

struct ResponseContent: Codable {
    let Plans: [PlanRecommendation]
    let Text_ans: String?
    let results: [AccommodationResult]
}

struct AccommodationResult: Codable {
    let link: String
    let name: String
    let summary: String
}

struct ApiResponse: Codable {
    let response: ResponseContent
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var lastCurrentUserMessageID: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private func processResponse(_ response: ApiResponse) -> Message {
        var fullMessage = ""
        var recommendations: [Recommendation] = []
        var multiDayPlan: MultiDayPlan? = nil
        
        // 處理多天行程
        if let firstPlan = response.response.Plans.first,
           firstPlan.Recommendation != nil {
            
            // 建立多天行程資料
            multiDayPlan = MultiDayPlan(
                startdate: "",
                enddate: "",
                planname: "",
                Plans: response.response.Plans.map { plan in
                    Plan(Recommendation: plan.Recommendation ?? [])
                }
            )
            
            // 生成顯示文字
            for (dayIndex, plan) in response.response.Plans.enumerated() {
                if let recommendations = plan.Recommendation {
                    fullMessage += "**第 \(dayIndex + 1) 天行程：**\n"
                    for recommendation in recommendations {
                        fullMessage += """
                            \(recommendation.Activity)：\(recommendation.Location)
                            地址：\(recommendation.Address)
                            \(recommendation.description)
                            建議停留時間：\(recommendation.latency)分鐘
                            \n
                            """
                    }
                    fullMessage += "\n"
                }
            }
        }
        // 處理單天行程
        else if let firstPlan = response.response.Plans.first,
                let spots = firstPlan.Recommendation_Spot {
            recommendations = spots
            for recommendation in spots {
                fullMessage += """
                    **\(recommendation.Location)**
                    地址：\(recommendation.Address)
                    \(recommendation.description)
                    建議停留時間：\(recommendation.latency)分鐘
                    """
                fullMessage += "\n\n"
            }
        }
        
        // 處理住宿推薦
        if !response.response.results.isEmpty {
            for (index, accommodation) in response.response.results.enumerated() {
                fullMessage += """
                    **\(accommodation.name)**
                    \(accommodation.summary)
                    [查看詳情](\(accommodation.link))
                    """
                
                if index < response.response.results.count - 1 {
                    fullMessage += "\n\n"
                }
            }
        }
        
        // 添加總結文字
        if let textAns = response.response.Text_ans {
            if !fullMessage.isEmpty {
                fullMessage += "\n\n"
            }
            fullMessage += textAns
        }
        
        return Message(
            content: fullMessage,
            isCurrentUser: false,
            recommendations: recommendations,
            multiDayPlan: multiDayPlan
        )
    }
    
    private func sendMessageToServer(query: String, token: String, endpoint: String) {
        guard let url = URL(string: endpoint) else {
            self.error = "Invalid URL"
            return
        }
        
        self.messages.append(Message(content: query, isCurrentUser: true))
        isLoading = true
        error = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ["query": query]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                let message = self.processResponse(response)
                self.messages.append(message)
            })
            .store(in: &cancellables)
    }
    
    // 公開的發送訊息方法
    func sendMessage(query: String, token: String) {
        sendMessageToServer(
            query: query,
            token: token,
            endpoint: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/chatbot"
        )
    }
    
    func sendGreenMessage(query: String, token: String) {
        sendMessageToServer(
            query: query,
            token: token,
            endpoint: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/greenchatbot"
        )
    }
}
