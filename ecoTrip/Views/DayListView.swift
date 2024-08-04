//
//  DayListView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import SwiftUI

struct DayListView: View {
    @EnvironmentObject var viewModel: TravelPlanViewModel
    var travelPlan: TravelPlan

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.days) { day in
                    NavigationLink(
                        destination: StopListView(day: day)
                            .environmentObject(viewModel)
                    ) {
                        Text(day.date)
                    }
                }
            }
            .navigationTitle(travelPlan.planname)
            .toolbar {
                Button(action: {
                    // 顯示新增日期的視圖
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            
        }
    }
}

//#Preview {
//    DayListView()
//}
