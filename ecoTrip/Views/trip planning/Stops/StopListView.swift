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
    @State private var showTransportation = true
    @EnvironmentObject var transportationViewModel: TransportationViewModel

    init(stops: [Stop], reloadData: @escaping () -> Void, accessToken: String) {
        self.stops = stops
        self._localStops = State(initialValue: stops)
        self.reloadData = reloadData
        self.accessToken = accessToken
    }
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                ZStack {
                    if showTransportation {
                        VStack(spacing: 0) {
                            ForEach(Array(localStops.enumerated().dropLast()), id: \.element.id) { index, stop in
                                Spacer()
                                    .frame(height: 70)
                                TransportationView(
                                    transportation: stop.transportationToNext,
                                    fromStopId: stop.id,
                                    toStopId: localStops[index + 1].id,
                                    fromStopName: stop.stopname,
                                    toStopName: localStops[index + 1].stopname,
                                    token: accessToken,
                                    reloadData: reloadData 
                                )
                                .environmentObject(transportationViewModel)
                            }
                            Spacer()
                                .frame(height: 70)
                        }
                       
                    }
                                    
                    VStack(spacing: 0) {
                        ForEach(Array(localStops.enumerated()), id: \.element.id) { index, stop in
                            HStack(alignment: .center, spacing: 10) {
                               
                                    Text("\(index + 1).")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                
                                    

                                StopView(stop: stop, showEditView: $showEditView, selectedPlaceName: $selectedPlaceName)
                                    .opacity(draggedStop == stop.id ? 0.5 : 1.0)
                                    .onDrag {
                                        self.draggedStop = stop.id
                                        withAnimation {
                                            showTransportation = false  // 開始拖曳時隱藏
                                        }
                                        return NSItemProvider()
                                    }
                                    .onDrop(of: [.text], delegate: StopDropDelegate(
                                        destinationStop: stop,
                                        stops: $localStops,
                                        draggedStopId: $draggedStop,
                                        onReorderComplete: sendReorderRequest
                                    ))
                            }
                            if index < localStops.count - 1 {
                                Spacer()
                                    .frame(height: 40) // TransportationView 的高度
                            }
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
