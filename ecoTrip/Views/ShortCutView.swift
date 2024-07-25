//
//  ShortCutView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/23.
//

import SwiftUI

struct ShortCutView: View {
    @State private var textInput = ""

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            // Search bar
            HStack {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .frame(width: 45, height: 45)
                    .padding(.leading, 10)
                
                // Text field
                TextField(" ", text: $textInput)
                    .onSubmit {
                        print(textInput)
                    }
                    .padding(.vertical, 10)
                
                
            }
            .background(Color.init(hex: "E8E8E8", alpha: 1.0))
            .cornerRadius(10)
            .padding()
            Spacer()
        }
    }
}

#Preview {
    ShortCutView()
}
