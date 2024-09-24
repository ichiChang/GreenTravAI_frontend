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
    let Activity: String
    let Address: String
    let Location: String
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private var recommendations: [Recommendation] = []
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
                self.messages.append(Message(content: response.Message, isCurrentUser: false))
                
                if let recommendations = response.Recommendation {
                    self.recommendations = recommendations
                    // 暂时存储recommendations，但不显示
                }
            }
            .store(in: &cancellables)
    }
}
