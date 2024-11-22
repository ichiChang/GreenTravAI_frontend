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
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    let lowCarbonPlaces = ["臺北市立動物園", "Blue磚塊廚房", "陽明山國家公園", "臺大農場農藝分場", "meet蘋果咖啡館", "Chinese Whispers 悄悄話餐酒館", "Chao 炒炒蔬食熱炒", "福華國際文教會館", "小公館人文旅舍", "初點良食 Dim sum shop", "臺北典藏植物園", "芝山文化生態綠園"]

    var body: some View {

        HStack {
            VStack(alignment: .leading) {
                HStack(alignment:.center){
                    Text(stop.stopname)
                        .bold()
                        .font(.system(size: 20))
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    if stop.Isgreen == true{
                        ZStack {
                            Circle()  // 白色圓形背景
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)

                            Image(systemName: "leaf.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                        }
                        .padding(.top, 10)

                     }
                }
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
                travelPlanViewModel.stopBeEdited = stop
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
        .frame(width: 310, height: 70)
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

