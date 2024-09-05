//
//  MenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/22.
//
import SwiftUI

struct MenuView: View {
    @State var index = 0
    @State var index1 = 0
    @State var indexd = 0
    @State var indexheart = 0
    @State var showChatView = false
    @State var showPlanMenuView = false
    @State var showProfileView = false
    @State var showShortCutView = false
    @State var showSearchView = true  // Set default view to SearchView
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        
        VStack(spacing:0) {
            
                if showProfileView {
                    ProfileView()
                }  else if showShortCutView {
                    OtherAppsView()
                } else if showSearchView {
                    SearchView(index1: $index1)
                } else if showPlanMenuView {
                    PlanMenuView(indexd: indexd).environmentObject(authViewModel)
                }
            
            CustomTabs(index: $index,
                           showChatView: $showChatView,
                           showPlanMenuView: $showPlanMenuView,
                           showProfileView: $showProfileView,
                           showSearchView: $showSearchView,
                           showShortCutView: $showShortCutView,
                           authViewModel: authViewModel)
        }
        .sheet(isPresented: $showChatView) {
            ChatView()
        }
        
    }
}

struct CustomTabs: View {
    @Binding var index: Int
    @Binding var showChatView: Bool
    @Binding var showPlanMenuView: Bool
    @Binding var showProfileView: Bool
    @Binding var showSearchView: Bool
    @Binding var showShortCutView: Bool
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
   
        HStack(alignment: .bottom, spacing: 10) {
            Button(action: {
                self.index = 0
                // Reset other views and ensure SearchView is visible
                resetViews()
                showSearchView = true
            }, label: {
                Image(index == 0 ? "searchGreen" : "searchWhite")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(10)
            })

            // Other buttons should also reset showSearchView when they are active
            Button(action: {
                self.index = 1
                resetViews()
                showShortCutView.toggle()
            }, label: {
                Image(index == 1 ? "squareGreen" : "square")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
            })

            Button(action: {
                self.index = 2
                resetViews()
                showPlanMenuView = true
            }, label: {
                Image(systemName: "suitcase")
                    .resizable()
                    .frame(width: 37, height: 40)
                    .padding(10)
                    .foregroundColor(index == 2 ? Color(hex: "B1D1A9", alpha: 1.0) : .white)
            
            })
           
            Button(action: {
                self.index = 3
      
                showChatView.toggle()
            }, label: {
                Image(index == 3 ? "agent" : "agent")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
            })

            Button(action: {
                self.index = 4
                resetViews()
                showProfileView = true
            }, label: {
                Image(index == 4 ? "userInfogreen" : "UserInfo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
            })
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "5E845B"))
        .navigationBarBackButtonHidden(true)

    }
    private func resetViews() {
            showProfileView = false
            showChatView = false
            showPlanMenuView = false
            showShortCutView = false
            showSearchView = false
        }
}


