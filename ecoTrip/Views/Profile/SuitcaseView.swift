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
                    VStack(spacing: 20) {
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
                                        Text("\(formatDate(plan.startdate)) - \(formatDate(plan.enddate))")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .bold()
                                        .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                                }
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 3)
                                )
                            }
                            .frame(width: 300, height: 100)
                        }
                    }
                    .padding()
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
}
