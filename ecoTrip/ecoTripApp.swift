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
        GMSServices.provideAPIKey("AIzaSyCsd9YigsuYiAt2G5XSiPGVZL5uJKltUPI")
        GMSPlacesClient.provideAPIKey("AIzaSyCsd9YigsuYiAt2G5XSiPGVZL5uJKltUPI")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(colorManager)
                .environmentObject(authViewModel)
        }
        
    }
}
