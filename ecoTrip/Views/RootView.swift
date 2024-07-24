//
//  RootView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/7/14.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isAuthenticated = false

    var body: some View {
       
        Group {
            if isAuthenticated {
                MenuView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
        .onReceive(authViewModel.$isAuthenticated) { newValue in
            isAuthenticated = newValue
        }
    }
}

#Preview {
    RootView()
}
