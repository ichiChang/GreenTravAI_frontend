//
//  ContentView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TravelPlanViewModel()
    @State var showChatView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.travelPlans) { travelPlan in
                        NavigationLink(
                            destination: DayListView(travelPlan: travelPlan)
                                .environmentObject(viewModel)
                        ) {
                            Text(travelPlan.name)
                        }
                    }
                }
                .navigationTitle("Travel Plans")
                .toolbar {
                    Button(action: {
                        // 顯示新增旅遊計劃的視圖
                    }) {
                        Image(systemName: "plus")
                    }
                   
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        showChatView.toggle()
                    } label: {
                        Image(.customerService)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                    .padding(.trailing)
                   
                   
                }
                
                }
                .padding(20)

            }
            .onAppear {
                viewModel.fetchTravelPlans()
            }
            .sheet(isPresented: $showChatView){
                ChatView()
            }
           
        }
    }


#Preview {
    ContentView()
}



