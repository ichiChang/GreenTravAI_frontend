//
//  ShortCutView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/23.
//

import SwiftUI

struct ShortCutView: View {
    @State private var textInput = ""
    @Environment(\.openURL) var openURL

    func openApp(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme) {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    // 如果無法打開應用程序，則打開網頁版本
                    openURL(URL(string: fallbackURL)!)
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: 45, height: 45)
                    .padding(.leading, 10)
                
                TextField(" ", text: $textInput)
                    .onSubmit {
                        print(textInput)
                    }
                    .padding(.vertical, 10)
            }
            .background(Color.init(hex: "E8E8E8", alpha: 1.0))
            .cornerRadius(10)
            .padding()
            
            // App shortcut buttons
            ScrollView {
                VStack(spacing: 15) {
                    Button(action: {
                        openApp(urlScheme: "googlechrome://", fallbackURL: "https://www.google.com")
                    }) {
                        Text("開啟 Google Chrome")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        openApp(urlScheme: "comgooglemaps://", fallbackURL: "https://www.google.com/maps")
                    }) {
                        Text("開啟 Google 地圖")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        openApp(urlScheme: "googlegmail://", fallbackURL: "https://www.google.com/gmail")
                    }) {
                        Text("開啟 Gmail")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        openApp(urlScheme: "klook://", fallbackURL: "https://www.klook.com")
                    }) {
                        Text("開啟 Klook")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        openApp(urlScheme: "uber://", fallbackURL: "https://www.uber.com")
                    }) {
                        Text("開啟 Uber")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ShortCutView()
}
