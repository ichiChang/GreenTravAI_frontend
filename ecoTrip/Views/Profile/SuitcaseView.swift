//
//  SuitcaseView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//

import SwiftUI

struct SuitcaseView: View {
    @StateObject private var viewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
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
                        ForEach(viewModel.travelPlans) { plan in
                            Button(action: {
                                // Action when a plan is tapped
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
        .onAppear {
            if let token = authViewModel.accessToken {
                viewModel.fetchTravelPlans(token: token)
            } else {
                viewModel.error = "No access token available"
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
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
