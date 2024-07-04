//
//  DropViewDelegate.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    let destinationItem: String
    @Binding var places: [String]
    @Binding var schedules: [String]
    @Binding var draggedItem: String?

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem else {
            return false
        }
        
        if draggedItem != destinationItem {
            let fromIndex = places.firstIndex(of: draggedItem)!
            let toIndex = places.firstIndex(of: destinationItem)!
            withAnimation {
                places.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                schedules.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
        
        self.draggedItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem else {
            return
        }
        
        if draggedItem != destinationItem {
            let fromIndex = places.firstIndex(of: draggedItem)!
            let toIndex = places.firstIndex(of: destinationItem)!
            withAnimation {
                places.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                schedules.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

