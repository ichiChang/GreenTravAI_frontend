//
//  EditTransportationView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/17.
//

import SwiftUI

struct EditTransportationView: View {
    @EnvironmentObject var transportationViewModel: TransportationViewModel
    @State private var selectedIndex: Int? = nil
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    let fromStopId: String
    let toStopId: String
    let fromStopName: String
    let toStopName: String
    let token: String
    var reloadData: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Top bar with back button
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                })
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            // 起點終點
            HStack {
                ZStack {
                    Circle()
                        .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                        .frame(width: 40, height: 40)
                    
                    Text("起")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 18))
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.init(hex: "E8E8E8", alpha: 1.0))
                        .frame(width: 270, height: 40)
                        .cornerRadius(15)
                    
                    Text(fromStopName)
                        .bold()
                        .font(.system(size: 18))
                        .padding()
                }
            }
            .padding(.vertical)
            
            HStack {
                ZStack {
                    Circle()
                        .foregroundStyle(Color.init(hex: "D26363", alpha: 1.0))
                        .frame(width: 40, height: 40)
                    
                    Text("終")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 18))
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.init(hex: "E8E8E8", alpha: 1.0))
                        .frame(width: 270, height: 40)
                        .cornerRadius(15)
                    
                    Text(toStopName)
                        .bold()
                        .font(.system(size: 18))
                        .padding()
                }
            }
            .padding(.bottom)
            
            // 交通工具
            if transportationViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))

            } else {
                ForEach(transportationViewModel.transportationModes.indices, id: \.self) { index in
                    let mode = transportationViewModel.transportationModes[index]
                    VStack {
                        HStack {
                            Image(systemName: getTransportationIcon(for: mode.mode))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(mode.timeSpent) 分鐘")
                                    .font(.system(size: 16, weight: .medium))
                                
                                if mode.emissionReduction > 0 {
                                    Text("相比開車減少 \(mode.emissionReduction) 克碳排放量")
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                }
                            }
                            .frame(alignment: .leading)
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedIndex = index
                            }) {
                                Image(systemName: selectedIndex == index ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                            }
                        }
                        .frame(width: 320)
                        .padding(10)
                    }
                    if index < transportationViewModel.transportationModes.count - 1 {
                        Divider()
                            .frame(minHeight: 2)
                            .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                            .padding(.bottom)
                            .frame(width: 330)
                    }
                }
            }
            
            Button(action: {
                if let selectedIndex = selectedIndex {
                    let selectedMode = transportationViewModel.transportationModes[selectedIndex]
                    transportationViewModel.updateTransportation(fromStopId: fromStopId, mode: selectedMode.mode, timeSpent: selectedMode.timeSpent, token: token) { success in
                        if success {
                            alertMessage = "交通方式更新成功"
                            reloadData()

                        } else {
                            alertMessage = "更新失敗，請稍後再試"
                        }
                        dismiss()
                    }
                } else {
                    alertMessage = "請選擇一種交通方式"
                    showAlert = true
                }
            }, label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            })
            .frame(width: 120, height: 42)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            transportationViewModel.fetchTransportations(fromStopId: fromStopId, toStopId: toStopId, token: token)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("提示"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }

    }
    
    private func getTransportationIcon(for mode: String) -> String {
        switch mode.lowercased() {
        case "walking": return "figure.walk"
        case "bicycling": return "bicycle"
        case "driving": return "car.rear.fill"
        case "transit": return "bus.fill"
        case "two_wheeler": return "scooter"
        default: return "questionmark.circle"
        }
    }
}
