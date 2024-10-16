//
//  PlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/1.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var viewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedDayIndex = 0
    @State private var showNewPlan = false
    @State private var showDemo = false
    @State private var showChatView = false
    @State private var isFirstAppear = true
    @State private var navigationPath = NavigationPath()
    @State private var showEditPlan = false
    @State private var hasExistingSchedule: Bool = false
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with back button and other controls
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                    })
                    .padding()
                    .offset(x:40,y:40)
                    
                    Spacer()
                        .frame(width:200)
                    
               
                    Button(action: {
                        showDemo.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                  
                    })
                    .padding(.horizontal)
                    .offset(x:40,y:40)
                    
                    // 地圖 button
//                    Button(action: {
//                        
//                    }, label: {
//                       
//                            Image(systemName: "location.circle")
//                                .foregroundStyle(.white)
//                                .font(.system(size: 30))
//                  
//                        
//                    })
//                    .padding(.horizontal)
//                    .offset(x:-10,y:40)
                    
                    Button(action: {
                        showChatView.toggle()
                    }, label: {
                        Image("agent")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(20)
                            .padding(.leading, 20)
                       
                    })
                    .padding(.horizontal)
                    .offset(x:-10,y:40)
                    
                }
                .ignoresSafeArea()
                .frame(height:50)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                // Days section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(Array(viewModel.days.enumerated()), id: \.element.id) { index, day in
                            Button(action: {
                                selectedDayIndex = index
                                selectedDate = dateFromString(day.date) ?? Date()
                                if let token = authViewModel.accessToken {
                                    viewModel.fetchStopsForDay(dayId: day.id, token: token)
                                }
                            }) {
                                Text(formatDate(day.date))
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedDayIndex == index ? .black : .white)
                                    .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(viewModel.days.count + 1)), height: 40)
                                    .background(selectedDayIndex == index ? .white : Color.init(hex: "8F785C", alpha: 1.0))
                            }
                        }
                        
                        // Add day button
                        Button(action: {
                            // Action to add a new day
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(viewModel.days.count + 1)), height: 40)
                        .background(Color.init(hex: "B8B7B7", alpha: 1.0))
                    }
                }
                .padding(.bottom)
                
                // Content based on selected day
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error)")
                } else if let dayStops = viewModel.dayStops, !dayStops.stops.isEmpty {
                    StopListView(stops: dayStops.stops, reloadData: reloadData)
                        .onAppear { hasExistingSchedule = true }
                    
                } else {
                    Text("No plans for this day yet.")
                        .foregroundColor(.gray)
                        .onAppear { hasExistingSchedule = false }
                }
                
                Spacer()
                
                // Add new plan button
                Button(action: {
                    showNewPlan.toggle()
                }) {
                    Text("新增行程")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // 隱藏返回按鈕
        .popupNavigationView(horizontalPadding: 40, show: $showDemo) {
            Demo(showDemo: $showDemo)
        }
        .sheet(isPresented: $showNewPlan) {
            NewStopView(showNewStop: $showNewPlan, hasExistingSchedule: hasExistingSchedule, reloadData: reloadData, selectedDate: selectedDate)
                .presentationDetents([.height(650)])
                .environmentObject(viewModel)
                .environmentObject(authViewModel)
            
        }
        .sheet(isPresented: $showChatView) {
            ChatView()
        }
        .onAppear {
            if let selectedPlan = viewModel.selectedTravelPlan,
               let token = authViewModel.accessToken {
                viewModel.fetchDaysForPlan(planId: selectedPlan.id, token: token) {
                    if let firstDay = viewModel.days.first {
                        selectedDate = dateFromString(firstDay.date) ?? Date()
                        print(selectedDate)
                        viewModel.fetchStopsForDay(dayId: firstDay.id, token: token)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M/d"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
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
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // 使用 GMT

        return formatter.date(from: dateString)
    }
    func reloadData() {
        if let token = authViewModel.accessToken {
            viewModel.fetchStopsForDay(dayId: viewModel.days[selectedDayIndex].id, token: token)
        }
    }
}
