//
//  NewTravelPlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/10.
//

import SwiftUI

struct NewTravelPlanView: View {
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showPlacePicker = false
    @State var showDatePicker = false
    @State private var showRidePicker = false
    @State private var selectedPlace = ""
    @State private var selectedRide = ""
    @State var selectedDates: Set<DateComponents> = []
    @State private var navigateToPlanView = false
    @State private var indexd = 0
    @State private var planName: String = ""
    @Binding var showNewJourney: Bool


    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.init(hex: "5E845B", alpha: 1.0)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            showNewJourney = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                        }
                        Spacer()
                    }
                    .frame(width: 280)
                    .padding()
                    
         
                    VStack(alignment: .leading) {
                        
                        Text("旅行計畫名稱")
                            .bold()
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                        
                        TextField("", text: $planName)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .frame(width: 280, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        
                        HStack {
                            Text("目的地")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showPlacePicker.toggle()
                        }, label: {
                            HStack {
                                Text(selectedPlace.isEmpty ? "台北市" : selectedPlace)
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 280, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                        
                        HStack {
                            Text("日期")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showDatePicker.toggle()
                        }, label: {
                            HStack {
                                Text(formatSelectedDates(selectedDates))
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 280, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                        
                        HStack {
                            Text("主要交通方式")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showRidePicker.toggle()
                        }, label: {
                            HStack {
                                Text(selectedRide.isEmpty ? "自行安排" : selectedRide)
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 280, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                    }
                   
                    Button(action: {
                        showNewJourney = false
                        createNewTravelPlan()
                    }) {
                        Text("確定")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "5E845B", alpha: 1.0))
                       
                    }
                    .frame(width: 100, height: 42)
                    .background(Color.white)
                    .cornerRadius(10)
          
                    
                  
                    if travelPlanViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))

                    }
                    
                    if let error = travelPlanViewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToPlanView) {
                    PlanView()
                }
            }
            .sheet(isPresented: $showPlacePicker) {
                PlacePicker(selectedPlace: $selectedPlace)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showDatePicker) {
                DatePick(selectedDates: $selectedDates)
                    .presentationDetents([.height(435)])
            }
            .sheet(isPresented: $showRidePicker) {
                RidePicker(selectedRide: $selectedRide)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func createNewTravelPlan() {
        guard let startDate = selectedDates.compactMap({ Calendar.current.date(from: $0) }).min(),
              let endDate = selectedDates.compactMap({ Calendar.current.date(from: $0) }).max() else {
            travelPlanViewModel.error = "Please select start and end dates"
            return
        }
        
        travelPlanViewModel.createTravelPlan(planName: planName, startDate: startDate, endDate: endDate, accessToken: authViewModel.accessToken) { success, errorMessage in
            if success {
                // Handle success
                showNewJourney = false
                print("Travel plan created successfully")
                if let token = authViewModel.accessToken {
                    travelPlanViewModel.fetchTravelPlans(token: token)
                }
                
            } else {
                // Handle failure
                travelPlanViewModel.error = errorMessage ?? "Unknown error occurred"
            }
        }
    }
    
    private func formatSelectedDates(_ dates: Set<DateComponents>) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let datesArray = dates.compactMap { Calendar.current.date(from: $0) }
        let sortedDates = datesArray.sorted()
        
        if let firstDate = sortedDates.first, let lastDate = sortedDates.last, firstDate != lastDate {
            return "\(dateFormatter.string(from: firstDate)) - \(dateFormatter.string(from: lastDate))"
        } else if let singleDate = sortedDates.first {
            return dateFormatter.string(from: singleDate)
        } else {
            return ""
        }
    }
}

