//
//  AuthViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/6/28.
//
import Combine
import SwiftUI

struct AuthResponse: Codable {
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

enum RegistrationError: Error {
    case passwordMismatch
    case networkError(Error)
    case decodingError(Error)
    case unknownError
    
    var description: String {
        switch self {
        case .passwordMismatch:
            return "Passwords do not match"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Registration failed: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred"
        }
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
    @Published var registrationError: RegistrationError?
    
    static let shared = AuthViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {}
    
    func register(email: String, password: String, confirmPassword: String, username: String, completion: @escaping (Bool) -> Void) {
        // Validate passwords match
        guard password == confirmPassword else {
            registrationError = .passwordMismatch
            completion(false)
            return
        }
        
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/register") else {
            registrationError = .unknownError
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registrationDetails = [
            "email": email,
            "password": password,
            "username": username
        ]
        
        // Print request details
        print("Registration Request URL: \(url)")
        print("Registration Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Registration Request Body: \(registrationDetails)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: registrationDetails)
            request.httpBody = jsonData
            
            // Print the actual JSON string being sent
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Registration Request JSON: \(jsonString)")
            }
        } catch {
            print("JSON Serialization Error: \(error)")
            registrationError = .unknownError
            completion(false)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RegistrationError.networkError(URLError(.badServerResponse))
                }
                
                // Print response status code
                print("Registration Response Status Code: \(httpResponse.statusCode)")
                
                guard 200...299 ~= httpResponse.statusCode else {
                    // Print error response body if available
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("Registration Error Response: \(errorString)")
                    }
                    throw RegistrationError.networkError(URLError(.badServerResponse))
                }
                
                // Print success response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Registration Success Response: \(responseString)")
                }
                
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionStatus in
                switch completionStatus {
                case .failure(let error):
                    print("Registration Error: \(error)")
                    if let registrationError = error as? RegistrationError {
                        self?.registrationError = registrationError
                    } else {
                        self?.registrationError = .networkError(error)
                    }
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                print("Registration Completed Successfully")
                self?.registrationError = nil
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    func login(email: String, password: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/login") else {
            loginError = .unknownError
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["email": email, "password": password]
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
