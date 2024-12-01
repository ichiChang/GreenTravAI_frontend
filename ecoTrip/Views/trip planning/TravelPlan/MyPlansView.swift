//
//  MyPlansView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/25.
//

import SwiftUI

struct MyPlansView: View {
    @State private var textInput = ""
    @State private var showNewJourney = false
    @State private var showPlanView = false
    @State private var selectedPlanId: String?
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: 45, height: 45)
                    .padding(.leading, 5)
                TextField(" ", text: $textInput)
                    .padding(.vertical, 10)
            }
            .frame(width: 300, height: 35)
            .background(Color.init(hex: "E8E8E8", alpha: 1.0))
            .cornerRadius(10)
            .padding()

            // Travel plans list
            ScrollView {
                VStack(spacing: 0) {
                    if travelPlanViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))

                    } else if let error = travelPlanViewModel.error {
                        Text("Error: \(error)")
                    } else if travelPlanViewModel.travelPlans.isEmpty {
                        Text("目前還沒有建立任何旅行計劃")
                    } else {
                        ForEach(travelPlanViewModel.travelPlans) { plan in
                            Button(action: {
                                selectedPlanId = plan.id
                                travelPlanViewModel.selectedTravelPlan = plan
                                showPlanView = true
                            }) {
                                PlanRowView(plan: plan)
                            }
                        }
                    }
                }
            }
            .refreshable {
                if let token = authViewModel.accessToken {
                    travelPlanViewModel.fetchTravelPlans(token: token)
                }
            }

            // New journey button
            Button(action: {
                showNewJourney = true
            }) {
                Text("新增旅行計畫")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 280, height: 40)
                    .background(Color(hex: "8F785C", alpha: 1.0))
                    .cornerRadius(15)
            }
            .padding(.bottom,30)
            .fullScreenCover(isPresented: $showPlanView) {
                if let _ = selectedPlanId {
                    PlanView()
                        .environmentObject(travelPlanViewModel)
                        .environmentObject(authViewModel)
                        .presentationDetents([.height(650)])

                }
            }

        }
        .onAppear {
            if let token = authViewModel.accessToken {
                travelPlanViewModel.fetchTravelPlans(token: token)
            }
        }
        .popupNavigationView(horizontalPadding: 40, show: $showNewJourney) {
            NewTravelPlanView(showNewJourney: $showNewJourney, reloadData: reloadData)
                .environmentObject(travelPlanViewModel)
                .environmentObject(authViewModel)
        }
    }
    func reloadData() {
        if let token = authViewModel.accessToken {
            travelPlanViewModel.fetchTravelPlans(token: token)
        }
    }
}

struct PlanRowView: View {
    let plan: TravelPlan
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(plan.planname)
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.leading)
                    .padding(.top)
                Text("\(formatDate(plan.startdate)) - \(formatDate(plan.enddate))")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.top, 3)
                    .padding(.bottom)
                    .padding(.leading)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                .padding(.trailing, 10)
        }
        .frame(width: 280, height: 90)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 2)
        )
        .padding()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}
