//
//  LoginView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/16.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        VStack{
            Spacer()
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 115)
                .padding(30)
            
            Button {
                
            }label:{
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
            
            Button{
                
            }label:{
                Text("Sign up").bold()
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                    .frame(width: 120, height: 40)
                   
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.init(hex: "5E845B", alpha: 1.0))
            .buttonBorderShape(.capsule)
            Spacer()
        }
    
    }
}

#Preview {
    LandingView()
}
