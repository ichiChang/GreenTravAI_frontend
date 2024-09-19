//
//  PlaceList.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct PlaceListView: View {
    @State private var draggedPlace: String?
    @State private var place: [String] = ["國立政治大學","台北市立動物園","指南宮","台北101觀景台","貓空纜車動物園站","道南河濱公園"]
    @State private var schedule: [String] = ["10:00 - 10:30", "10:30 - 11:00", "11:00 - 11:30", "11:30 - 12:00", "12:00 - 12:30", "12:30 - 13:00"]
    @State private var navigateToRide = false
    @State private var navigationPath = NavigationPath()
    @State private var showEditView = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false, content: {
                VStack(spacing: 0){
                    ForEach(Array(zip(place.indices, place)), id: \.1) { index, place in
                        PlaceView(name: place, time: schedule[index], showEditView: $showEditView)
                            .onDrag({
                                self.draggedPlace = place
                                return NSItemProvider()
                            })
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: place, places: $place, schedules: $schedule, draggedItem: $draggedPlace))
                        
                        // 仅在不是最后一个元素时添加按钮
                        if index < self.place.count - 1 {
                            HStack{
                                Spacer()
                                    .frame(width:30)
                                Rectangle()
                                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                    .frame(width:7,height:40)
                                
                                
                                Image(systemName: "bicycle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:25, height:25)
                                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                Text("6 分鐘")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                
                                Button(action: {
                                    navigateToRide = true
                                }) {
                                    Image(systemName: "highlighter")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:18, height:18)
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal)
                                
                                Spacer()
                                
                            }
                            .frame(width: 300)
                        }
                    }
                }
            })
            .fullScreenCover(isPresented: $navigateToRide) {  // Present PlanView as a full-screen cover
                ChangeRideView()
            }
            .sheet(isPresented: $showEditView) {
                NewPlanView(showNewPlan: $showEditView)
                    .presentationDetents([.height(650)])
                
            }
        }
    }
}

#Preview {
    PlaceListView()
}
