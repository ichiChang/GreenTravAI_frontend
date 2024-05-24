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

    private var cancellables: Set<AnyCancellable> = []

    func fetchTravelPlans() {
        guard let url = URL(string: "http://your-api-url/travelplans") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TravelPlan].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.travelPlans = $0 }
            .store(in: &cancellables)
    }

    func fetchDays(for travelPlanId: Int) {
        guard let url = URL(string: "http://your-api-url/travelplans/\(travelPlanId)/days") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Day].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.days = $0 }
            .store(in: &cancellables)
    }

    func fetchStops(for dayId: Int) {
        guard let url = URL(string: "http://your-api-url/days/\(dayId)/stops") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Stop].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.stops = $0 }
            .store(in: &cancellables)
    }
}

