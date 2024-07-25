//
//  SiteInfoView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/28.
//

import SwiftUI
import MapKit

struct SiteInfoView: View {
    @Environment(\.dismiss) var dismiss
    let place: Place

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                    Spacer()
                    Button(action: {
                        openInMaps()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .padding()
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                    Button(action: {
                        // 按鈕動作
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .padding(5)
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                }
                .zIndex(1)
                
                AsyncImage(url: URL(string: place.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .ignoresSafeArea()
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(place.placename).bold()
                        .font(.title2)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    
                    Text(place.address)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                }
                Spacer()
                
                Button(action: {
                    // 按鈕動作
                }) {
                    Text("加入行程")
                        .bold()
                        .font(.system(size: 15))
                        .padding(15)
                        .foregroundStyle(.white)
                        .background(Color.init(hex: "5E845B", alpha: 1.0))
                        .cornerRadius(15)
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding(.bottom)

            HStack {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding()
            
            HStack {
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding()
            
            HStack {
                Image(systemName: "clock")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Text(place.openingTime)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    func openInMaps() {
        let coordinates = CLLocationCoordinate2D(latitude: Double(place.lat) ?? 0, longitude: Double(place.long) ?? 0)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.placename
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}


