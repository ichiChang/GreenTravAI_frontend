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
    @StateObject private var placeViewModel = PlaceViewModel()
    let placeModel: PlaceModel

    // Add State Variables
    @State private var showJPicker = false
    @State private var selectedRecommendation: Recommendation?
    @State private var navigateToPlanView = false
    @State private var showMapView = false
    @State private var coordinates: CLLocationCoordinate2D?

    @ObservedObject var travelPlanViewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    

    func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeModel.address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first,
                      let location = placemark.location {
                DispatchQueue.main.async {
                    self.coordinates = location.coordinate
                }
            } else {
                print("No coordinates found for the address.")
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                ZStack(alignment:.top){
                    
                    HStack(spacing:0) {
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .padding(10)
                                
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 15, height: 20)
                                    .bold()
                                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                            }
                        }
                        Spacer()
                        Button(action: {
                            // 地圖
                            showMapView.toggle()

                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .padding(10)
                                Image(systemName: "map.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                            }
                        }
                        .sheet(isPresented: $showMapView) {
                            if let coordinates = coordinates {
                                let stop = Stop(
                                    id: UUID().uuidString,
                                    Address: placeModel.address,
                                    stopname: placeModel.name,
                                    StartTime: "",
                                    EndTime: "",
                                    Note: "",
                                    transportationToNext: nil,
                                    coordinates: [coordinates.longitude, coordinates.latitude],
                                    Isgreen: nil
                                )
                                MapView(stops: [stop])
                            } else {
                                Text("No valid coordinates available")
                            }
                        }

                        Button(action: {
                            if let token = authViewModel.accessToken {
                                placeViewModel.addToFavorites(userId: "66a6561a8246fa416f8e06e2",
                                                               placeId: placeModel.id,
                                                               token: token) { success, errorMessage in
                                    if success {
                                        DispatchQueue.main.async {
                                            placeViewModel.favorites[placeModel.id] = true
                                        }
                                    } else if let errorMessage = errorMessage {
                                        print("Error: \(errorMessage)")
                                    }
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .padding(10)
                                Image(systemName: placeViewModel.favorites[placeModel.id, default: false] ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(hex: "5E845B", alpha: 1.0))
                                    .bold()
                            }
                        }






                    }
                    
                    .padding()
                    .padding(.bottom)
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                }
                .frame(height:50)
                
                
                if let image = placeModel.image {
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width:400, height: 250)
                        .clipped()
                        .padding(.bottom)
                    
                    
                }
                
                ScrollView{
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(placeModel.name).bold()
                                .font(.system(size: 20))
                                .padding(.top, 10)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                            
                            Text(placeModel.address)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Convert placeModel to Recommendation
                            let recommendation = Recommendation(
                                Activity: placeModel.name,
                                Address: placeModel.address,
                                Location: placeModel.name,
                                description: "推薦的地方",
                                latency: "30"
                            )
                            selectedRecommendation = recommendation
                            showJPicker.toggle()
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
                    .padding(.horizontal)
                    
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .padding(.vertical)
                    
                    if let websiteString = placeModel.website, !websiteString.isEmpty,
                       let websiteURL = URL(string: websiteString) {
                        Link(destination: websiteURL) {
                            HStack {
                                Image(systemName: "globe")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.horizontal)
                                    .foregroundColor(Color(hex: "444444"))
                                Text(getDomainPrefix(from: websiteString))
                                    .font(.system(size: 15))
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Optionally handle the case where the website is not available
                        Text("網站資訊不可用")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }

                    
                    Divider()
                        .frame(minHeight: 2)
                        .frame(width: 330)
                        .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .padding()
                    
                    if let phoneNumber = placeModel.phoneNumber, !phoneNumber.isEmpty {
                        HStack {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal)
                                .foregroundColor(Color(hex: "444444"))
                            Text(phoneNumber)
                                .foregroundColor(Color(hex: "444444"))
                                .font(.system(size: 15))
                            Spacer()
                        }
                        .padding(.horizontal)
                    } else {
                        Text("電話資訊不可用")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }

                    
                    Divider()
                        .frame(minHeight: 2)
                        .frame(width: 330)
                        .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .padding()
                    
                    
                    if let openingHours = placeModel.currentOpeningHours, !openingHours.isEmpty {
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal)
                                .foregroundColor(Color(hex: "444444"))
                            Text(openingHours)
                                .foregroundColor(Color(hex: "444444"))
                                .font(.system(size: 15))
                            Spacer()
                        }
                        .padding(.horizontal)
                    } else {
                        Text("營業時間資訊不可用")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }

                    
                    
                    Spacer()
                    
                }

                
            }
            .onAppear {
                geocodeAddress()
            }
            .popupNavigationView(horizontalPadding: 40, show: $showJPicker) {
                JourneyPicker(
                    showJPicker: $showJPicker,
                    chatContent: selectedRecommendation?.description ?? "",
                    recommendation: selectedRecommendation,
                    navigateToPlanView: $navigateToPlanView
                )
                .environmentObject(travelPlanViewModel)
                .environmentObject(authViewModel)
            }
            .navigationDestination(isPresented: $navigateToPlanView) {
                PlanView()
                    .environmentObject(travelPlanViewModel)
                    .environmentObject(authViewModel)
            }
        }
        .navigationBarHidden(true)


    }
    private func getDomainPrefix(from urlString: String) -> String {
        guard let url = URL(string: urlString), let host = url.host else {
            return "未知網站"
        }
        return host
    }


    
}

