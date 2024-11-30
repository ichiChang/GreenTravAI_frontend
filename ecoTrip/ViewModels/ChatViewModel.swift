//
//  ChatViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/25.
//

import Foundation
import Combine

struct Recommendation: Codable {
    let Activity: String
    let Address: String
    let Location: String
    let description: String
    let latency: String

}

struct PlanRecommendation: Codable {
    let Recommendation: [Recommendation]
}

struct ApiResponse: Codable {
    let response: ResponseContent
}

struct AccommodationResult: Codable {
    let link: String
    let name: String
    let summary: String
}

struct ResponseContent: Codable {
    let Plans: [PlanRecommendation]
    let Text_ans: String?
    let results: [AccommodationResult]
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

        // Immediately add user message
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
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            }, receiveValue: { response in
                var fullMessage = ""
                var recommendations: [Recommendation] = []
                var accommodationResults: [AccommodationResult] = []

                // Extract recommendations
                if let firstPlan = response.response.Plans.first {
                    recommendations = firstPlan.Recommendation
                    for recommendation in recommendations {
                        fullMessage += """
                        **\(recommendation.Location)**
                        地址：\(recommendation.Address)
                        \(recommendation.description)
                        建議停留時間：\(recommendation.latency)分鐘
                        """

                        fullMessage += "\n\n"
                    }
                }

                // Extract accommodation results
                accommodationResults = response.response.results
                if !accommodationResults.isEmpty {
                    for (index, accommodation) in accommodationResults.enumerated() {
                        fullMessage += """
                        **\(accommodation.name)**
                        \(accommodation.summary)
                        [查看詳情](\(accommodation.link))
                        """

                        if index < accommodationResults.count - 1 {
                            fullMessage += "\n\n"
                        }
                    }
                }

                // Add Text_ans after recommendations
                if let textAns = response.response.Text_ans, !textAns.isEmpty {
                    if !fullMessage.isEmpty {
                        fullMessage += "\n\n"
                    }
                    fullMessage += textAns
                }

                // Create assistant message with recommendations
                let assistantMessage = Message(content: fullMessage, isCurrentUser: false, recommendations: recommendations)
                self.messages.append(assistantMessage)
            })
            .store(in: &cancellables)
    }

    
    func sendGreenMessage(query: String, token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/chatbot") else {
            self.error = "Invalid URL"
            return
        }
        
        // Immediately add user message
        let newUUID = UUID()
        self.messages.append(Message(id: newUUID, content: query, isCurrentUser: true))
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
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { response in
                var fullMessage = ""
                
                // Add recommendations first if available
                if let firstPlan = response.response.Plans.first {
                    
                    for recommendation in firstPlan.Recommendation {
                        fullMessage += """
                                                **\(recommendation.Location)**
                                                地址：\(recommendation.Address)
                                                \(recommendation.description)
                                                建議停留時間：\(recommendation.latency)分鐘
                                                """
                        
                        // Add double line break after each recommendation except the last one
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
                
                // Add Text_ans after recommendations
                if let textAns = response.response.Text_ans, !textAns.isEmpty {
                    if !fullMessage.isEmpty {
                        fullMessage += "\n\n"
                    }
                    fullMessage += textAns
                }
                
                // Add as a single message
                self.messages.append(Message(content: fullMessage, isCurrentUser: false))
            }
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
