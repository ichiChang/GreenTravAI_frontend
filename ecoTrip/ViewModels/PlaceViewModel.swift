//
//  PlaceViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/6/28.
//

import Foundation
import Combine

class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favorites: [String: Bool] = [:]

    private var cancellables = Set<AnyCancellable>()
    
    func fetchPlaces() {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/places/") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
            .decode(type: [Place].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] places in
                self?.places = places
                places.forEach { place in
                    if self?.favorites[place.id] == nil {
                        self?.favorites[place.id] = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    func toggleFavorite(for id: String) {
            favorites[id]?.toggle()
            favorites = favorites    // 重新賦值以觸發更新

        
        }
}
