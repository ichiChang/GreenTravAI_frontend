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

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(colorManager)

        }
    }
}
