//
//  TransportationView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/19.
//

import SwiftUI

struct TransportationView: View {
    let transportation: Transportation?
    @State private var navigateToRide = false
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 30)
            Rectangle()
                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                .frame(width: 7, height: 40)
            
            if let transport = transportation {
                Image(systemName: getTransportationIcon(for: transport.Mode))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                Text("\(transport.TimeSpent ?? 0) 分鐘")
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
            } else {
                Text("交通方式未指定")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                navigateToRide = true
            }) {
                Image(systemName: "highlighter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(width: 300)
        .fullScreenCover(isPresented: $navigateToRide) {
            ChangeRideView()
        }
    }
    
    private func getTransportationIcon(for mode: String?) -> String {
        switch mode?.lowercased() {
        case "walking": return "figure.walk"
        case "bicycling": return "bicycle"
        case "driving": return "car"
        case "transit": return "bus"
        default: return "questionmark.circle"
        }
    }
}

struct TransportationView_Previews: PreviewProvider {
    static var previews: some View {
        TransportationView(transportation: Transportation(LowCarbon: true, Mode: "bicycling", TimeSpent: 15))
    }
}
