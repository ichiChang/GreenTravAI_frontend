//
//  ecoTripApp.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/12.
//

import SwiftUI

@main
struct ecoTripApp: App {
    var colorManager = ColorManager()
    @StateObject private var authViewModel = AuthViewModel.shared
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(colorManager)
                .environmentObject(authViewModel)
        }
        
    }
}

