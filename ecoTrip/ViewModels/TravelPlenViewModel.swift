//
//  TravelPlanViewModel.swift
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
    @Published var stopBeEdited: Stop?
    
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
    
    func fetchDaysForPlan(planId: String, token: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/days/day-in-plan") else {
            self.error = "Invalid URL"
            completion?()
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
            .sink { completionResult in
                if case .failure(let error) = completionResult {
                    self.error = error.localizedDescription
                }
                completion?()
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
    
    func copyPlan(token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/CreateAll_demo") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Network error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(false, "Server error")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }.resume()
    }
    
    func reorderStops(stops: [Stop], token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/stops/EditStop") else {
            completion(false, "Invalid URL")
            return
        }
        
        let reorderedStops = stops.enumerated().map { index, stop in
            [
                "stop_id": stop.id,
                "previous_stop_id": index == 0 ? nil : stops[index - 1].id
            ]
        }
        
        let requestBody = ["stops": reorderedStops]
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
        
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard response is HTTPURLResponse else {
                    completion(false, "Invalid response")
                    return
                }
                
                guard let data = data else {
                    completion(false, "No data received")
                    return
                }
                
                do {
                    let dayStops = try JSONDecoder().decode(DayStops.self, from: data)
                    self?.dayStops = dayStops
                    completion(true, nil)
                } catch {
                    completion(false, "Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    func editStop(stopId: String, name: String, note: String, address: String, latency: Int, token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/stops/\(stopId)") else {
            completion(false, "Invalid URL")
            return
        }
        
        let requestBody: [String: Any] = [
            "Name": name,
            "note": note,
            "address": address,
            "latency": latency
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
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
    func createMultiDayPlan(plan: MultiDayPlan, token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/travel_plans/CreateAll") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(plan)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                        // 刷新行程列表
                        self?.fetchTravelPlans(token: token)
                        completion(true, nil)
                    } else {
                        completion(false, "Server error: HTTP \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        } catch {
            completion(false, "Encoding error: \(error.localizedDescription)")
        }
    }
    func refreshTravelPlans(token: String) {
        fetchTravelPlans(token: token)
    }
}
