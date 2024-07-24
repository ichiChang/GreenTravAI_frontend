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

    
     var body: some View {
         ScrollView(showsIndicators: false, content: {
             VStack{
                 ForEach(Array(zip(place.indices, place)), id: \.1) { index, place in
                     PlaceView(name: place, time: schedule[index])
                         .onDrag({
                             self.draggedPlace = place
                             return NSItemProvider()
                         })
                         .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: place, places: $place, schedules: $schedule, draggedItem: $draggedPlace))

                 }
             }
         })
     }
        
}

#Preview {
    PlaceListView()
}

