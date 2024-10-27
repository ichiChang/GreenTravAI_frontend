//
//  TransportationViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/10/20.
//

import Foundation
import Combine

struct TransportationMode: Identifiable {
    let id = UUID()
    let mode: String
    let timeSpent: Int
    let emissionReduction: Int
}

class TransportationViewModel: ObservableObject {
    @Published var transportationModes: [TransportationMode] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTransportations(fromStopId: String, toStopId: String, token: String) {
        isLoading = true
        error = nil
        
        let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/transportations/choose")!
        let body = ["FromStopId": fromStopId, "ToStopId": toStopId]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [String: [String: Int]].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.transportationModes = response.map {
                    TransportationMode(
                        mode: $0.key,
                        timeSpent: $0.value["Timespent"] ?? 0,
                        emissionReduction: $0.value["emission_reduction_amount"] ?? 0
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    func updateTransportation(fromStopId: String, mode: String, timeSpent: Int, token: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/transportations/choose")!
        let body = [
            "FromStopId": fromStopId,
            "mode": mode,
            "TimeSpent": timeSpent
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.response as? HTTPURLResponse }
            .map { $0?.statusCode == 200 }
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    print("Error updating transportation: \(error.localizedDescription)")
                    completion(false)
                }
            } receiveValue: { success in
                completion(success)
            }
            .store(in: &cancellables)
    }
}
