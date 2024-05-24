//
//  StopListView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/5/24.
//

import SwiftUI

struct StopListView: View {
    @EnvironmentObject var viewModel: TravelPlanViewModel
    var day: Day

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.stops) { stop in
                    VStack(alignment: .leading) {
                        Text(stop.name)
                            .font(.headline)
                        Text("\(stop.startTime) - \(stop.endTime)")
                            .font(.subheadline)
                        Text(stop.note ?? "")
                            .font(.body)
                    }
                }
            }
            .navigationTitle(day.date)
            .toolbar {
                Button(action: {
                    // 顯示新增行程的視圖
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.fetchStops(for: day.id)
        }
    }
}

#Preview {
    StopListView()
}
