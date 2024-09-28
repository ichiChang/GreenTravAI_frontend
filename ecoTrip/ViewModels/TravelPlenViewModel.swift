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
    @Published var dayStops: DayStops?
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

    func fetchDaysForPlan(planId: String, token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/days/day-in-plan") else {
            self.error = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: String] = ["TravelPlanId": planId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Day].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] days in
                self?.days = days
            }
            .store(in: &cancellables)
    }

    
    func fetchStopsForDay(dayId: String, token: String) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/stops/StopinDay") else {
            self.error = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: String] = ["day_id": dayId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: DayStops.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] dayStops in
                self?.dayStops = dayStops
            }
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
                    // Assuming the newly created travel plan is returned in the response
                    if let data = data,
                       let newTravelPlan = try? JSONDecoder().decode(TravelPlan.self, from: data) {
                        self?.travelPlans.append(newTravelPlan)
                        completion(true, nil)
                    } else {
                        completion(false, "Failed to parse new travel plan")
                    }
                } else {
                    completion(false, "Server error: HTTP \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    func getLastStopForDay(dayId: String, token: String, completion: @escaping (Stop?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/stops/StopinDay") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ["day_id": dayId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let dayStops = try JSONDecoder().decode(DayStops.self, from: data)
                DispatchQueue.main.async {
                    completion(dayStops.stops.last)
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    func addStopToDay(requestBody: [String: Any], token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/stops/") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
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
