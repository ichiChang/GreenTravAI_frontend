//
//  ChatViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/25.
//

import Foundation
import Combine

struct ApiResponse: Codable {
    let Message: String
    let Recommendation: [Recommendation]?
}

struct Recommendation: Codable {
    let Name: String
    let Address: String
    let Latency: Int
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var lastRecommendation: Recommendation?
    
    private var cancellables = Set<AnyCancellable>()

    func sendMessage(query: String, token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/easyMessage") else {
            self.error = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = ["query": query]
        request.httpBody = try? JSONEncoder().encode(body)

        isLoading = true
        error = nil

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
                self.messages.append(Message(content: query, isCurrentUser: true))
                
                var botMessage = response.Message
                
                if let recommendations = response.Recommendation {
                    for recommendation in recommendations {
                        botMessage += "\n\n地點：\(recommendation.Name)\n地址：\(recommendation.Address)\n建議停留時間：\(self.formatLatency(recommendation.Latency))"
                    }
                    if let first = recommendations.first {
                        self.lastRecommendation = first
                    }
                }
                
                self.messages.append(Message(content: botMessage, isCurrentUser: false))
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
