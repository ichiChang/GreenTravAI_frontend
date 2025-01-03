//
//  MultiDayPlanSetupView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/12/6.
//

import SwiftUI
import Combine

struct MultiDayPlanSetupView: View {
    @Binding var isShowing: Bool
    let multiDayPlan: MultiDayPlan
    @Environment(\.dismiss) var dismiss
    @State private var planName: String = ""
    @State private var startDate = Date()
    @State private var showCustomAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @State private var navigateToPlanMenuView = false

    private var endDate: Date {
        let numberOfDays = multiDayPlan.Plans.count - 1 // -1 是因為起始日也算一天
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: startDate) ?? startDate
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack(spacing: 20) {
                    
                    // Close button
                    Button(action: {
                        isShowing = false
                    }, label: {
                        HStack {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                            Spacer()
                        }
                        .frame(width: 280)
                    })
                    .padding()
                    
                    Spacer()
                    
                    // Title
                    Text("新增旅遊計畫")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color(hex: "8F785C"))
                        .padding()
                    
                    
                    // Plan name input
                    // Search bar
                    
                    TextField("旅遊計畫名稱", text: $planName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 280)
                        .padding()
                    
                    
                    
                    // Date pickers
                    VStack(alignment: .leading, spacing: 15) {
                        DatePicker("起始日期",
                                   selection: $startDate,
                                   displayedComponents: .date)
                        .frame(width: 280)
                        
                        HStack{
                            Spacer()
                            Text("總天數：\(multiDayPlan.Plans.count)天")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 280)
                        
                    }
                    .padding()
                    
                    
                    // Confirm button
                    Button(action: createMultiDayPlan) {
                        Text("確認")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color(hex: "8F785C", alpha: 1.0))
                            .cornerRadius(15)
                    }
                    .disabled(planName.isEmpty)
                    .padding()
                    
                    Spacer()
                    
                }
                .popupNavigationView(horizontalPadding: 40, show: $showCustomAlert, useDefaultFrame: false) {
                    CustomAlertView(
                        isPresented: $showCustomAlert,
                        title: alertTitle,
                        message: alertMessage,
                        primaryButtonText: "查看行程",
                        secondaryButtonText: "取消",
                        primaryButtonAction: {
                            dismiss()
                        },
                        secondaryButtonAction: {
                            isShowing = false
                        }
                    )
                    
                }
                // ProgressView 顯示條件
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "5E845B", alpha: 1.0)))
                        .scaleEffect(1.5)
                        .padding()
                }
                
            }
 
        }
    }
    
    private func createMultiDayPlan() {
        guard let token = authViewModel.accessToken else {
            showAlert(title: "錯誤", message: "尚未登入")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // 計算結束日期
        let endDate = Calendar.current.date(byAdding: .day,
                                            value: multiDayPlan.Plans.count - 1,
                                            to: startDate) ?? startDate

        var updatedPlan = multiDayPlan
        updatedPlan.startdate = dateFormatter.string(from: startDate)
        updatedPlan.enddate = dateFormatter.string(from: endDate)
        updatedPlan.planname = planName

        // 顯示 ProgressView
        isLoading = true

        travelPlanViewModel.createMultiDayPlan(plan: updatedPlan, token: token) { success, error in
            // 隱藏 ProgressView
            isLoading = false

            if success {
                alertTitle = "行程建立成功"
                alertMessage = "您的多天行程已成功新增。\n是否查看行程列表？"
                showCustomAlert = true
            } else {
                showAlert(title: "行程建立失敗", message: error ?? "未知錯誤")
            }
        }
    }

    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showCustomAlert = true
    }
}
