//
//  AuthViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/6/28.
//

import Combine
import SwiftUI

// 檢查是否已經定義了 AuthResponse，並確保其定義如下
struct AuthResponse: Codable {
    var accessToken: String
    var refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var user: User?

    private var cancellables: Set<AnyCancellable> = []

    func login(username: String, password: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails)

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .replaceError(with: AuthResponse(accessToken: "", refreshToken: ""))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                if !response.accessToken.isEmpty {
                    self.accessToken = response.accessToken
                    self.refreshToken = response.refreshToken
                    self.isAuthenticated = true
                    print("Login successful, isAuthenticated: \(self.isAuthenticated)")
                }
            }
            .store(in: &cancellables)
    }
}
