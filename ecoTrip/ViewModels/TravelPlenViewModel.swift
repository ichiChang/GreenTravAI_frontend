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

    func fetchTravelPlans() {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TravelPlan].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.travelPlans = $0 }
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

    func createTravelPlan(planName: String, startDate: Date, endDate: Date, accessToken: String?) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/") else {
            self.error = "Invalid URL"
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
            self.error = "No access token available"
            return
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.error = "Failed to encode request body"
            return
        }

        isLoading = true
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TravelPlan.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] newTravelPlan in
                self?.travelPlans.append(newTravelPlan)
            }
            .store(in: &cancellables)
    }
}
