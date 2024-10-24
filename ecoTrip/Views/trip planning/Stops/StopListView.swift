//
//  StopListView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct StopListView: View {
    let stops: [Stop]
    @State private var localStops: [Stop]
    @State private var draggedStop: String?
    @State private var navigateToRide = false
    @State private var navigationPath = NavigationPath()
    @State private var showEditView = false
    @State private var selectedPlaceName: String = ""
    @State private var selectedDate: Date = Date()
    var reloadData: () -> Void
    var accessToken: String
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel

    init(stops: [Stop], reloadData: @escaping () -> Void, accessToken: String) {
        self.stops = stops
        self._localStops = State(initialValue: stops)
        self.reloadData = reloadData
        self.accessToken = accessToken
    }
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(stops.enumerated()), id: \.element.id) { index, stop in
                        StopView(stop: stop, showEditView: $showEditView, selectedPlaceName: $selectedPlaceName)
                            .opacity(draggedStop == stop.id ? 0.5 : 1.0)
                            .onDrag {
                                self.draggedStop = stop.id
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text], delegate: StopDropDelegate(
                                destinationStop: stop,
                                stops: $localStops,
                                draggedStopId: $draggedStop,
                                onReorderComplete: sendReorderRequest
                            ))
                        
                        if index < stops.count - 1 {
                            TransportationView(
                                transportation: stop.transportationToNext,
                                fromStopId: stop.id,
                                toStopId: stops[index + 1].id,
                                fromStopName: stop.stopname,
                                toStopName: stops[index + 1].stopname,
                                token: accessToken
                            )
                        }
                    }
                }
                
            }
            .sheet(isPresented: $showEditView) {
                NewStopView(showNewStop: $showEditView,
                            hasExistingSchedule: false,
                            reloadData: reloadData,
                            selectedDate: selectedDate)
                    .presentationDetents([.height(650)])
            }
        }
        .sheet(isPresented: $showEditView) {
            EditPlanView(stop: $selectedPlaceName)
                 .presentationDetents([.height(650)])
         }
    }
    // 新增：重新排序後發送到後端的函數
    private func sendReorderRequest() {
        print("Original order:")
        stops.forEach { stop in
            print(" - \(stop.stopname)")
        }
        
        print("\nNew order:")
        localStops.forEach { stop in
            print(" - \(stop.stopname)")
        }
        
        guard !localStops.isEmpty else { return }
        guard let dayId = travelPlanViewModel.dayStops?.day_id else { return }
        
        travelPlanViewModel.reorderStops(stops: localStops, token: accessToken) { success, error in
            if !success {
                print("Reorder failed, reverting to original order")
                withAnimation {
                    self.localStops = self.stops
                }
                if let error = error {
                    print("Reorder error: \(error)")
                }
            }
        }
    }
}

struct StopDropDelegate: DropDelegate {
    let destinationStop: Stop
    @Binding var stops: [Stop]
    @Binding var draggedStopId: String?
    let onReorderComplete: () -> Void
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        // 在拖曳結束時呼叫 onReorderComplete
        onReorderComplete()
        draggedStopId = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedStopId {
            let fromIndex = stops.firstIndex(where: { $0.id == draggedStopId })
            if let fromIndex {
                let toIndex = stops.firstIndex(where: { $0.id == destinationStop.id })
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.stops.move(
                            fromOffsets: IndexSet(integer: fromIndex),
                            toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                        )
                    }
                }
            }
        }
    }
}
