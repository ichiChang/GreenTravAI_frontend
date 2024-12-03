//
//  ChatViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/25.
//

import Foundation
import Combine

// 保持兩種可能的推薦結構
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
    
    func sendMessage(query: String, token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/chatbot") else {
            self.error = "Invalid URL"
            return
        }
        
        let newUUID = UUID()
        self.messages.append(Message(content: query, isCurrentUser: true))
        self.lastCurrentUserMessageID = newUUID.uuidString
        
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
                
                // 檢查是否為多天行程（檢查是否有 Recommendation）
                if let firstPlan = response.response.Plans.first,
                   firstPlan.Recommendation != nil {
                    // 如果是多天行程，生成純文字輸出
                    var fullMessage = ""
                    
                    // 添加每天的行程資訊
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
                    
                    // 添加文字總結
                    if let textAns = response.response.Text_ans {
                        fullMessage += textAns
                    }
                    
                    self.messages.append(Message(content: fullMessage, isCurrentUser: false))
                    return
                }
                
                // 如果是單天行程（原本的格式），保持原有處理邏輯
                var fullMessage = ""
                var recommendations: [Recommendation] = []
                
                if let firstPlan = response.response.Plans.first,
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
                
                if let textAns = response.response.Text_ans {
                    if !fullMessage.isEmpty {
                        fullMessage += "\n\n"
                    }
                    fullMessage += textAns
                }
                
                if !fullMessage.isEmpty {
                    self.messages.append(Message(content: fullMessage, isCurrentUser: false, recommendations: recommendations))
                }
            })
            .store(in: &cancellables)
    }
    
    
        func sendGreenMessage(query: String, token: String) {
            guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/greenchatbot") else {
                self.error = "Invalid URL"
                return
            }
            
            let newUUID = UUID()
            self.messages.append(Message(content: query, isCurrentUser: true))
            self.lastCurrentUserMessageID = newUUID.uuidString
            
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
                    
                    // 檢查是否為多天行程（檢查是否有 Recommendation）
                    if let firstPlan = response.response.Plans.first,
                       firstPlan.Recommendation != nil {
                        // 如果是多天行程，生成純文字輸出
                        var fullMessage = ""
                        
                        // 添加每天的行程資訊
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
                        
                        // 添加文字總結
                        if let textAns = response.response.Text_ans {
                            fullMessage += textAns
                        }
                        
                        self.messages.append(Message(content: fullMessage, isCurrentUser: false))
                        return
                    }
                    
                    // 如果是單天行程（原本的格式），保持原有處理邏輯
                    var fullMessage = ""
                    var recommendations: [Recommendation] = []
                    
                    if let firstPlan = response.response.Plans.first,
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
                    
                    if let textAns = response.response.Text_ans {
                        if !fullMessage.isEmpty {
                            fullMessage += "\n\n"
                        }
                        fullMessage += textAns
                    }
                    
                    if !fullMessage.isEmpty {
                        self.messages.append(Message(content: fullMessage, isCurrentUser: false, recommendations: recommendations))
                    }
                })
                .store(in: &cancellables)
        }
    
    private func formatLatency(_ latency: Int) -> String {
        let hours = latency / 60
        let minutes = latency % 60
        
        if hours > 0 {
            if minutes > 0 {
                return "\(hours)小時\(minutes)分鐘"
            } else {
                return "\(hours)小時"
            }
        } else {
            return "\(minutes)分鐘"
        }
    }
}
