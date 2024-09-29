//
//  ContentView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/29.
//


import SwiftUI
import GoogleMaps

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            GoogleMapViewRepresentable(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("Search for places", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    .onChange(of: searchText) { newValue in
                        viewModel.searchPlaces(query: newValue)
                        viewModel.showingSearchResults = !newValue.isEmpty
                    }
                
                if viewModel.showingSearchResults && !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults) { place in
                        Button(action: {
                            viewModel.selectPlace(place)
                        }) {
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .font(.headline)
                                Text(place.address)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(height: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                if let selectedPlace = viewModel.selectedPlace {
                    PlaceDetailView(place: selectedPlace)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}
