//
//  PlaceView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct StopView: View {
    let stop: Stop
    @Binding var showEditView: Bool
    @Binding var selectedPlaceName: String
    
    var body: some View {

        HStack {
            VStack(alignment: .leading) {
                Text(stop.stopname)
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(.bottom, 3)
                Text("\(formatTime(stop.StartTime)) - \(formatTime(stop.EndTime))")
                    .bold()
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
            }
            .padding()
           
            
            Spacer()
            
            Button(action: {
                selectedPlaceName = stop.stopname
                showEditView = true
            }) {
                Image(systemName: "highlighter")
                    .resizable()
                    .bold()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                    .padding(.trailing, 10)
            }
            .padding()
        }
        .frame(width: 330, height: 70)
        .background(Color.init(hex: "F5F5F5", alpha: 1.0))
        .cornerRadius(15)
        
    }
    
    private func formatTime(_ timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        }
        return timeString
    }
}

