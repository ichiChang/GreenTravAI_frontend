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

enum LoginError: Error {
    case invalidCredentials
    case networkError(Error)
    case decodingError(Error)
    case unknownError
    
    var description: String {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var user: User?
    @Published var loginError: LoginError?

    private var cancellables: Set<AnyCancellable> = []

    func login(username: String, password: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/login") else {
            loginError = .unknownError
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw LoginError.networkError(URLError(.badServerResponse))
                }
                if httpResponse.statusCode == 401 {
                    throw LoginError.invalidCredentials
                }
                guard 200...299 ~= httpResponse.statusCode else {
                    throw LoginError.networkError(URLError(.badServerResponse))
                }
                return data
            }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let loginError = error as? LoginError {
                        self?.loginError = loginError
                    } else if error is DecodingError {
                        self?.loginError = .decodingError(error)
                    } else {
                        self?.loginError = .networkError(error)
                    }
                    print("Login failed: \(self?.loginError?.description ?? "Unknown error")")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.accessToken = response.accessToken
                self.refreshToken = response.refreshToken
                self.isAuthenticated = true
                print("Login successful, isAuthenticated: \(self.isAuthenticated)")
            }
            .store(in: &cancellables)
    }

    func logout() {
        isAuthenticated = false
        accessToken = nil
        refreshToken = nil
        user = nil
        loginError = nil
    }
}
