//
//  MyPlansView 2.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/26.
//



import SwiftUI

struct JournetPicker: View {
    @State private var textInput = ""
    @State private var showNewJourney = false
    @State private var showPlanView = false
    @State private var selectedPlanId: String?
    @EnvironmentObject var viewModel: TravelPlanViewModel
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
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text("Error: \(error)")
                    } else if viewModel.travelPlans.isEmpty {
                        Text("No travel plans found")
                    } else {
                        ForEach(viewModel.travelPlans) { plan in
                            Button(action: {
                                selectedPlanId = plan.id
                                viewModel.selectedTravelPlan = plan
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
                    viewModel.fetchTravelPlans(token: token)
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
            .padding(10)
            .fullScreenCover(isPresented: $showPlanView) {
                if let _ = selectedPlanId {
                    PlanView()
                        .environmentObject(viewModel)
                        .environmentObject(authViewModel)
                }
            }
            .sheet(isPresented: $showNewJourney) {
                NewJourneyView(showNewJourney: $showNewJourney)
                    .environmentObject(viewModel)
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            if let token = authViewModel.accessToken {
                viewModel.fetchTravelPlans(token: token)
            }
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
