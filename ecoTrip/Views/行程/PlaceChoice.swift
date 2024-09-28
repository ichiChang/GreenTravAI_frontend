//
//  PlaceChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/8.
//
import SwiftUI
import MapKit

struct PlaceChoice: View {
    @Binding var navigateToPlaceChoice: Bool
    @StateObject private var viewModel = LocationSuggestionViewModel()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var showSearchBar = false
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: viewModel.selectedLocation.map { [$0] } ?? []) { item in
                MapMarker(coordinate: item.mapItem.placemark.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        navigateToPlaceChoice = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button(action: {
                        showSearchBar.toggle()
                        if showSearchBar {
                            isSearchFocused = true
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                if showSearchBar {
                    VStack {
                        TextField("搜尋地點", text: $viewModel.searchText)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .focused($isSearchFocused)
                        
                        if !viewModel.suggestions.isEmpty {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                        Button(action: {
                                            viewModel.selectLocation(suggestion)
                                            showSearchBar = false
                                        }) {
                                            VStack(alignment: .leading) {
                                                Text(suggestion.title)
                                                    .font(.headline)
                                                Text(suggestion.subtitle)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(Color.white)
                                        }
                                        Divider()
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                if let location = viewModel.selectedLocation {
                    VStack {
                        Text(location.mapItem.name ?? "")
                            .font(.headline)
                        Text(location.mapItem.placemark.title ?? "")
                            .font(.subheadline)
                        Button(action: {
                            print("Selected place: \(location.mapItem.name ?? "")")
                            navigateToPlaceChoice = false
                        }) {
                            Text("確定")
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "5E845B"))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
