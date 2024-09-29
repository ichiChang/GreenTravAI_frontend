//
//  PlaceChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/8.
//
import SwiftUI
import GoogleMaps

struct PlaceChoice: View {
    @StateObject private var viewModel = MapViewModel()
    @Binding var selectedPlace: PlaceModel?
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    
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
                            selectedPlace = place
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
                    Button(action: {
                        dismiss()
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
            }
        }
    }
}

struct GoogleMapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        let option = GMSMapViewOptions()
        option.frame = .zero
        let mapView = GMSMapView(options: option)
        mapView.delegate = context.coordinator
        
        context.coordinator.setupLocationHandler(mapView: mapView)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        context.coordinator.updateMap(mapView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapViewRepresentable
        var mapView: GMSMapView?
        
        init(_ parent: GoogleMapViewRepresentable) {
            self.parent = parent
        }
        
        func setupLocationHandler(mapView: GMSMapView) {
            self.mapView = mapView
            parent.viewModel.locationUpdateHandler = { [weak self] location in
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                self?.mapView?.animate(to: camera)
            }
        }
        
        func updateMap(mapView: GMSMapView) {
            mapView.isMyLocationEnabled = parent.viewModel.userLocationAuthorized
            mapView.settings.myLocationButton = parent.viewModel.userLocationAuthorized
            
            if let selectedPlace = parent.viewModel.selectedPlace,
               let coordinate = selectedPlace.coordinate {
                let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                      longitude: coordinate.longitude,
                                                      zoom: 15)
                mapView.animate(to: camera)
                
                mapView.clear() // Clear existing markers
                let marker = GMSMarker(position: coordinate)
                marker.title = selectedPlace.name
                marker.snippet = selectedPlace.address
                marker.map = mapView
            }
        }
    }
}
