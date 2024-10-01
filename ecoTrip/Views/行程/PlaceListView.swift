//
//  PlaceList.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct PlaceListView: View {
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
                NewPlanView(showNewPlan: $showEditView, hasExistingSchedule: false, reloadData: reloadData)
                    .presentationDetents([.height(650)])
            }
        }
        .fullScreenCover(isPresented: $navigateToRide) {
            ChangeRideView()
        }
    }
}

//struct PlaceListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(stops: [
//            Stop(id: "1", stopname: "國立政治大學", StartTime: "2024-09-05 10:00", EndTime: "2024-09-05 10:30", Note: nil, transportationToNext: nil),
//            Stop(id: "2", stopname: "台北市立動物園", StartTime: "2024-09-05 11:00", EndTime: "2024-09-05 11:30", Note: nil, transportationToNext: nil)
//        ], reloadData: .constant)
//    }
//}
