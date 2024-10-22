//
//  NewStopView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/6.
//

import SwiftUI

struct NewStopView: View {
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var arrivalTime: Date = Date()
    @State private var departureTime: Date = Date()
    @State private var textInput = ""
    @Binding var showNewStop: Bool
    @State private var navigateToPlaceChoice = false
    @State var hours: Int = 0
    @State var minutes: Int = 0
    let hasExistingSchedule: Bool
    @State private var selectedPlace: PlaceModel?
    @State private var showAlert = false
    @State private var alertMessage = ""
    var reloadData: () -> Void
    let selectedDate: Date

    var body: some View {
        VStack(spacing: 0){
            
            Button{
                showNewStop = false
            }label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .bold()
                    .frame(width:42, height: 15)
                    .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                
                
            }
            .padding()

            NavigationStack {
                Button {
                    navigateToPlaceChoice = true
                } label: {
                    HStack {
                        Text(selectedPlace?.name ?? "選擇地點")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .frame(alignment: .leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .bold()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                    }
                    .frame(width: 295,height: 45)
                }
                .navigationDestination(isPresented: $navigateToPlaceChoice) {
                    PlaceChoice(selectedPlace: $selectedPlace)
                }

                
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom,10)
                
                if !hasExistingSchedule {
                    HStack {
                        Text("抵達時間")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .frame(maxWidth: 150, alignment: .leading)
                        
                        DatePicker(
                            "",
                            selection: $arrivalTime,
                            in: selectedDate...selectedDate.addingTimeInterval(24*60*60),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .frame(width: 145, height: 45)
                        .scaleEffect(1.1)
                    }
                    .frame(width: 295)
                    
                    Divider()
                        .frame(minHeight: 2)
                        .frame(width: 295)
                        .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .padding(.bottom,10)
                }
                
                HStack {
                    Text("預計停留時間")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 130, alignment: .leading)
                        .layoutPriority(1)  // Give the text priority to take up space

 
                    Picker("", selection: $hours){
                            ForEach(0..<9, id: \.self) { i in
                                Text("\(i) hrs").tag(i)
                                    .font(.system(size: 20))
                            }
                        }.pickerStyle(WheelPickerStyle())
                        Picker("", selection: $minutes){
                            ForEach(0..<60, id: \.self) { i in
                                Text("\(i) ").tag(i)
                                    .font(.system(size: 20))
                            }
                        }.pickerStyle(WheelPickerStyle())
                    
                }
                .frame(width: 295, height: 90)

                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom,10)
                
                HStack{
                    
                    Text("行程細節備註")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 150, alignment: .leading)
                    
                    Spacer()
                }
                .frame(width: 295,height: 45)
                
                // Text field
                ZStack {
                    
                    // Background Color
                    Color(hex: "D9D9D9")
                        .cornerRadius(20)
                        .frame(width: 300, height: 150)
                    
                    // TextEditor with padding
                    TextEditor(text: $textInput)
                        .padding()
                        .background(Color.clear)
                        .frame(width: 300, height: 150)
                        .cornerRadius(20)
                        .colorMultiply(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .font(.custom("HelveticaNeue", size: 15))
                    
                }
                .padding([.horizontal], 30)
                
                Button(action: {
                    addNewStop()
                }, label: {
                    Text("確定")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 295, height: 40)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding(.vertical)

            }
            .onAppear {
                // 設置初始的抵達時間為選中日期的開始
                print(selectedDate)
                arrivalTime = selectedDate
            }

        }
    }
    private func addNewStop() {
        guard let selectedPlace = selectedPlace else {
            showAlert(message: "請選擇地點")
            return
        }

        guard let dayId = travelPlanViewModel.dayStops?.day_id else {
            showAlert(message: "無法獲取當前日期ID")
            return
        }

        guard let token = authViewModel.accessToken else {
            showAlert(message: "請先登入")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var requestBody: [String: Any] = [
            "Name": selectedPlace.name,
            "note": textInput,
            "DayId": dayId,
            "latency": hours * 60 + minutes,
            "address": selectedPlace.address,
        ]
        if let lastStopId = travelPlanViewModel.dayStops?.stops.last?.id, !lastStopId.isEmpty {
            requestBody["prev_stop"] = lastStopId
        } else {
            requestBody["StartTime"] = dateFormatter.string(from: arrivalTime)
            requestBody["prev_stop"] = NSNull()
        }

        travelPlanViewModel.addStopToDay(requestBody: requestBody, token: token) { success, error in
            if success {
                showAlert(message: "成功添加新的停留點")
                showNewStop = false  // 關閉 NewPlanView
                reloadData()
            } else {
                showAlert(message: "添加失敗：\(error ?? "未知錯誤")")
            }
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}


