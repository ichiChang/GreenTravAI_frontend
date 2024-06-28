//
//  LoginView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/16.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                authViewModel.login(username: username, password: password)
            }) {
                Text("Login").bold()
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                    .frame(width: 120, height: 40)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.init(hex: "5E845B", alpha: 1.0))
            .buttonBorderShape(.capsule)
            .padding(10)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
