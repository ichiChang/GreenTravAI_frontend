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
    @State var showPlanView = false
    @State var showProfileView = false
    @State var showShortCutView = false
    @State var showSearchView = true  // Set default view to SearchView
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if showProfileView {
                ProfileView()
            }  else if showShortCutView {
                ShortCutView()
            } else if showSearchView {
                SearchView(index1: $index1)
            }

            CustomTabs(index: $index,
                           showChatView: $showChatView,
                           showPlanView: $showPlanView,
                           showProfileView: $showProfileView,
                           showSearchView: $showSearchView,
                           showShortCutView: $showShortCutView,
                           authViewModel: authViewModel)
        }
        .sheet(isPresented: $showChatView) {
            ChatView()
        }
        .sheet(isPresented: $showPlanView) {
            PlanMenuView()
        }
    }
}

struct CustomTabs: View {
    @Binding var index: Int
    @Binding var showChatView: Bool
    @Binding var showPlanView: Bool
    @Binding var showProfileView: Bool
    @Binding var showSearchView: Bool
    @Binding var showShortCutView: Bool
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        Spacer()
        HStack(alignment: .bottom, spacing: 10) {
            Button(action: {
                self.index = 0
                // Reset other views and ensure SearchView is visible
                showProfileView = false
                showChatView = false
                showPlanView = false
                showShortCutView = false
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
                showShortCutView.toggle()
            }, label: {
                Image(index == 1 ? "squareGreen" : "square")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
            })

            Button(action: {
                self.index = 2
                showPlanView.toggle()
            }, label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: "F5EFCF"))
                        .frame(width: 60, height: 60)

                    Image(systemName: "plus")
                       .resizable()
                       .frame(width: 40, height: 40)
                       .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                       .padding(10)
                }
            })
            .sheet(isPresented: $showPlanView) {
                PlanMenuView().environmentObject(authViewModel)
            }

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
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
