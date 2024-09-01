//
//  ChatViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/25.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var error: String?

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
            .decode(type: String.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { response in
                self.messages.append(Message(content: query, isCurrentUser: true))
                self.messages.append(Message(content: response, isCurrentUser: false))
            }
            .store(in: &cancellables)
    }
}
