//
//  ecoTripApp.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/12.
//

import SwiftUI
import GoogleMaps
import GooglePlacesSwift

@main
struct ecoTripApp: App {
    var colorManager = ColorManager()
    @StateObject private var authViewModel = AuthViewModel.shared
    
    init() {
        GMSServices.provideAPIKey("AIzaSyAo5En89oMTSmHr3RN3O8muFoauk3iGOlE")
        PlacesClient.provideAPIKey("AIzaSyAo5En89oMTSmHr3RN3O8muFoauk3iGOlE")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(colorManager)
                .environmentObject(authViewModel)
        }
        
    }
}

