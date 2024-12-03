//
//  PlanMenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/24.
//
import SwiftUI

struct PlanMenuView: View {
    @StateObject private var viewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .myPlans

    enum Tab {
        case myPlans
        case popularPlans
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab selection
            HStack {
                Spacer()
                Text("我的旅行計畫")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(selectedTab == .myPlans ? Color.white : Color(hex: "D1CECE", alpha: 1.0))
//                    .underline(selectedTab == .myPlans)
                    .onTapGesture {
                        selectedTab = .myPlans
                    }
//                Spacer()
//                Text("熱門旅行計畫")
//                    .font(.system(size: 20))
//                    .bold()
//                    .foregroundColor(selectedTab == .popularPlans ? Color.white : Color(hex: "D1CECE", alpha: 1.0))
//                    .underline(selectedTab == .popularPlans)
//                    .onTapGesture {
//                        selectedTab = .popularPlans
//                    }
                Spacer()
            }
            .frame(height: 50)
            .background(Color.init(hex: "5E845B", alpha: 1.0))

            if selectedTab == .myPlans {
                MyPlansView()
                    .environmentObject(viewModel)
                    .environmentObject(authViewModel)
            } else {
                PopularPlansView()
            }
        }
        .navigationBarBackButtonHidden(true)

    }

}
