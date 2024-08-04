//
//  TravelPlenViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import Combine
import SwiftUI

class TravelPlanViewModel: ObservableObject {
    @Published var travelPlans: [TravelPlan] = []
    @Published var selectedTravelPlan: TravelPlan?
    @Published var days: [Day] = []
    @Published var stops: [Stop] = []
    @Published var isLoading: Bool = false
    @Published var error: String?

    private var cancellables: Set<AnyCancellable> = []

    func fetchTravelPlans(token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/") else {
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
                print("Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    throw URLError(.userAuthenticationRequired)
                }
                return output.data
            }
            .decode(type: [TravelPlan].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                    print("Error fetching travel plans: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] travelPlans in
                self?.travelPlans = travelPlans
            }
            .store(in: &cancellables)
    }

    func fetchDays(for travelPlanId: Int) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travelplans/\(travelPlanId)/days") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Day].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.days = $0 }
            .store(in: &cancellables)
    }

    func fetchStops(for dayId: Int) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/days/\(dayId)/stops") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Stop].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.stops = $0 }
            .store(in: &cancellables)
    }

    func createTravelPlan(planName: String, startDate: Date, endDate: Date, accessToken: String?, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/") else {
            completion(false, "Invalid URL")
            return
        }

        let dateFormatter = ISO8601DateFormatter()
        let requestBody: [String: Any] = [
            "planname": planName,
            "startdate": dateFormatter.string(from: startDate),
            "enddate": dateFormatter.string(from: endDate)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(false, "No access token available")
            return
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }

        isLoading = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Invalid response")
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    completion(true, nil)
                } else {
                    completion(false, "Server error: HTTP \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
