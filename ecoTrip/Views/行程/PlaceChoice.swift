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
       
            VStack {
                HStack{
                    
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .bold()
                            .frame(width:10, height: 15)
                            .foregroundStyle(.black)
                        
                    }
                    .padding()
                    
                    TextField("請輸入地點名稱", text: $searchText)
                        .padding()
                        .frame(width: 300, height:35)
                        .background(Color(hex: "E8E8E8"))
                        .cornerRadius(20)
                        .onChange(of: searchText) { newValue in
                            viewModel.searchPlaces(query: newValue)
                            viewModel.showingSearchResults = !newValue.isEmpty
                        }
                }
                .padding(.vertical,10)
              
                ZStack{
                    GoogleMapViewRepresentable(viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        
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
                            .scrollContentBackground(.hidden)
                            .frame(height: 200)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                        if let selectedPlace = viewModel.selectedPlace {
                            PlaceDetailView(place: selectedPlace)
                                .transition(.move(edge: .bottom))
                            Button(action: {
                                dismiss()
                            }) {
                                Text("確定")
                                    .bold()
                                    .padding()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width:150,height:40)
                                    .background(Color(hex: "5E845B"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)

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
