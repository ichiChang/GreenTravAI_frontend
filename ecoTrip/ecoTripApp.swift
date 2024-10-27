//
//  ecoTripApp.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/12.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct ecoTripApp: App {
    var colorManager = ColorManager()
    @StateObject private var authViewModel = AuthViewModel.shared
    
    init() {
        // 從配置文件或環境變量讀取 API key
        if let apiKey = Bundle.main.infoDictionary?["GoogleMapsAPIKey"] as? String {
            GMSServices.provideAPIKey(apiKey)
            GMSPlacesClient.provideAPIKey(apiKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(colorManager)
                .environmentObject(authViewModel)
        }
    }
}
