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
        if let filePath = Bundle.main.path(forResource: "APIkey", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let apiKey = plist["GoogleMapsAPIKey"] as? String {
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
