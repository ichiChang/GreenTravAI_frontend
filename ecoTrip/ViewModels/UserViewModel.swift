//
//  UserViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/8/4.
//

import SwiftUI
import Combine

struct EcoContribution: Codable {
    let emission_reduction: Int
    let green_spot_rate: Int
    let green_trans_rate: Int
}
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var error: String?
    @Published var isLoading = false
    
    // Add new properties for eco contribution
    @Published var emissionReduction: Int = 0
    @Published var greenSpotRate: CGFloat = 0
    @Published var greenTransRate: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUserInfo(token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/userInfo") else {
            self.error = "Invalid URL"
            return
        }
        
        isLoading = true
        error = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    func fetchEcoContribution(token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/CalCarbon") else {
            self.error = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: EcoContribution.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] contribution in
                self?.emissionReduction = contribution.emission_reduction
                self?.greenSpotRate = CGFloat(contribution.green_spot_rate)
                self?.greenTransRate = CGFloat(contribution.green_trans_rate)
            }
            .store(in: &cancellables)
    }
}

