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
        VStack(spacing:0){
            if let image = place.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 130)
                    .clipped()
            }
            HStack {
                VStack(alignment: .leading, spacing:0) {
                    Spacer()
                    Text(place.name)
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.leading,10)
                        .padding(.top,10)
                    
                    Text(place.address)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .padding(.leading,10)
                    if let phoneNumber = place.phoneNumber {
                        Text("電話: \(phoneNumber)")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.leading,10)
                    }
                    if let rating = place.rating {
                        Text("評分: \(rating, specifier: "%.1f") / 5.0")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.leading,10)
                            .padding(.bottom,20)
                    }
                    if let distance = place.distance {
                        Text("Distance: \(distance / 1000, specifier: "%.2f") km")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.leading,10)
                    }
                }
                .frame(width: 280,height: 80, alignment: .leading)
                .background(Color.white)
            }
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(20)
    }
}
