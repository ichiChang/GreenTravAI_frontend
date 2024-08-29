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
    @State private var selectedTab: Tab = .myPlans
    @State private var showPlanView = false  // Add this state to trigger PlanView

    enum Tab {
        case myPlans
        case popularPlans
    }
    
    var body: some View {
        VStack {
            HStack {
                 Spacer()
                 
                 Text("我的旅行計畫")
                     .font(.system(size: 20))
                     .bold(selectedTab == .myPlans)
                     .foregroundColor(.white)
                     .underline(selectedTab == .myPlans)
                     .onTapGesture {
                         selectedTab = .myPlans
                     }
                 
                 Spacer()
                 
                 Text("熱門旅行計畫")
                     .font(.system(size: 20))
                     .bold(selectedTab == .popularPlans)
                     .foregroundColor(.white)
                     .underline(selectedTab == .popularPlans)
                     .onTapGesture {
                         selectedTab = .popularPlans
                     }
                 
                 Spacer()
             }
             .ignoresSafeArea()
             .frame(height: 50)
             .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            // Search bar
            HStack {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .frame(width: 45, height: 45)
                    .padding(.leading, 5)
                
                // Text field
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
            
            HStack {
                Text("2024")
                    .foregroundStyle(Color.init(hex: "999999", alpha: 1.0))
                    .font(.system(size: 15))
                Spacer()
            }
            .frame(width: 300)
            
            // Journey buttons
            Button(action: {
                showPlanView = true  // Trigger PlanView
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("台南三日遊")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.bottom)
                            .padding(.leading)
                            .padding(.top)
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
            })
            .fullScreenCover(isPresented: $showPlanView) {  // Present PlanView as a full-screen cover
                PlanView(indexd: .constant(0))
            }
            
            Button(action: {
                
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("宜蘭兩日遊")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.bottom)
                            .padding(.leading)
                            .padding(.top)
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
                .padding(.bottom)
            })
            
            // New journey button
            Button(action: {
                showNewJourney = true
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
            .padding()
            
            Spacer()
        }
        .popupNavigationView(horizontalPadding: 40, show: $showNewJourney) {
            NewJourneyView(showNewJourney: $showNewJourney)
        }
    }
}

#Preview {
    PlanMenuView()
}
