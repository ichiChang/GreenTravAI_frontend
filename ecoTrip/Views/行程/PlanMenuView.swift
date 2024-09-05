//
//  PlanMenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/24.
//
import SwiftUI

struct PlanMenuView: View {
    @State private var textInput = ""
    @State private var showNewJourney = false
    @State private var showPopPlans = false
    @State private var selectedTab: Tab = .myPlans
    @State private var showPlanView = false  // Add this state to trigger PlanView
    @State var indexd: Int
    @StateObject private var viewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    enum Tab {
        case myPlans
        case popularPlans
    }
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Spacer()
                 
                Text("我的旅行計畫")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(selectedTab == .myPlans ? Color.white : Color(hex: "D1CECE", alpha: 1.0))
                    .underline(selectedTab == .myPlans)
                    .onTapGesture {
                        selectedTab = .myPlans
                        showPopPlans = false
                    }
                 
                Spacer()
                 
                Text("熱門旅行計畫")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(selectedTab == .popularPlans ? Color.white : Color(hex: "D1CECE", alpha: 1.0))
                    .underline(selectedTab == .popularPlans)
                    .onTapGesture {
                        selectedTab = .popularPlans
                        showPopPlans = true
                    }
                 
                Spacer()
            }
            .ignoresSafeArea()
            .frame(height: 50)
            .background(Color.init(hex: "5E845B", alpha: 1.0))

            NavigationStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 45, height: 45)
                        .padding(.leading, 5)
                    
                    TextField(" ", text: $textInput)
                        .onSubmit {
                            print(textInput)
                        }
                        .padding(.vertical, 10)
                }
                .frame(width: 300, height: 35)
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding()

                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text("Error: \(error)")
                    } else if viewModel.travelPlans.isEmpty {
                        Text("No travel plans found")
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("2024")
                                        .foregroundStyle(Color.init(hex: "999999", alpha: 1.0))
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                .frame(width: 300)
                                
                                ForEach(viewModel.travelPlans) { plan in
                                    Button(action: {
                                        print(plan.id)
                                        showPlanView = true  // Trigger PlanView
                                    }) {
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
                                                    .padding(.top,3)
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
                                }
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showPlanView) {
                    PlanView(indexd: $indexd)
                }
                .onAppear {
                    if let token = authViewModel.accessToken {
                        viewModel.fetchTravelPlans(token: token)
                    } else {
                        viewModel.error = "No access token available"
                    }
                }
                // Use navigationDestination to show PopularPlansView
                 .navigationDestination(isPresented: $showPopPlans) {
                     PopularPlansView()
                 }

                // New journey button
                Button(action: {
                    showNewJourney = true
                    let newPlanName = "New Plan"
                    let startDate = Date()
                    let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!
                    
                    if let token = authViewModel.accessToken {
                        viewModel.createTravelPlan(planName: newPlanName, startDate: startDate, endDate: endDate, accessToken: token) { success, errorMessage in
                            if success {
                                indexd = viewModel.travelPlans.count - 1
                                showPlanView = true
                            } else if let errorMessage = errorMessage {
                                viewModel.error = errorMessage
                            }
                        }
                    } else {
                        viewModel.error = "No access token available"
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                        
                        Text("新增旅行計畫")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                })
                .frame(width: 280, height: 40)
                .padding(10)
            }
        }
        .popupNavigationView(horizontalPadding: 40, show: $showNewJourney) {
            NewJourneyView(showNewJourney: $showNewJourney)
        }
    }
}

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"
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
