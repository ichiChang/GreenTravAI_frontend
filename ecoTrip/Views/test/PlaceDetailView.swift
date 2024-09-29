//
//  PlaceDetailView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/29.
//


import SwiftUI

struct PlaceDetailView: View {
    let place: PlaceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let image = place.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            }
            Text(place.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(place.address)
                .font(.subheadline)
            
            if let phoneNumber = place.phoneNumber {
                Text("電話: \(phoneNumber)")
                    .font(.subheadline)
            }
            
            if let rating = place.rating {
                Text("評分: \(rating, specifier: "%.1f") / 5.0")
                    .font(.subheadline)
            }
            
            if let distance = place.distance {
                Text("Distance: \(distance / 1000, specifier: "%.2f") km")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
