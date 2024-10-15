//
//  StopListView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct StopListView: View {
    let stops: [Stop]
    @State private var navigateToRide = false
    @State private var navigationPath = NavigationPath()
    @State private var showEditView = false
    @State private var draggedPlace: String?
    var reloadData: () -> Void

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(stops.enumerated()), id: \.element.id) { index, stop in
                        PlaceView(stop: stop, showEditView: $showEditView)
                            .onDrag({
                                self.draggedPlace = stop.stopname
                                return NSItemProvider()
                            })
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: stop.stopname, places: .constant(stops.map { $0.stopname }), schedules: .constant([]), draggedItem: $draggedPlace))
                        
                        if index < stops.count - 1 {
                            TransportationView(transportation: stop.transportationToNext)
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditView) {
                NewStopView(showNewPlan: $showEditView, hasExistingSchedule: false, reloadData: reloadData)
                    .presentationDetents([.height(650)])
            }
        }
        .fullScreenCover(isPresented: $navigateToRide) {
            ChangeRideView()
        }
    }
}
