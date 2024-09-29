////
////  MapSearchView.swift
////  ecoTrip
////
////  Created by Ichi Chang on 2024/9/29.
////
//
//
//import SwiftUI
//import MapKit
//import CoreLocation
//import Combine
//
//struct MapSearchView: View {
//    @StateObject private var viewModel = MapViewModel()
//    @State private var searchText = ""
//    @State private var showSearchResults = false
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.landmarks) { landmark in
//                MapAnnotation(coordinate: landmark.coordinate) {
//                    VStack {
//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundColor(.red)
//                            .font(.title)
//                        Text(landmark.name)
//                            .font(.caption)
//                            .background(Color.white.opacity(0.7))
//                            .cornerRadius(5)
//                    }
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                HStack {
//                    TextField("Search for a place", text: $searchText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .padding()
//                        .onChange(of: searchText) { _ in
//                            viewModel.debouncedSearch(searchText)
//                            showSearchResults = !searchText.isEmpty
//                        }
//                }
//
//                if showSearchResults {
//                    List(viewModel.landmarks) { landmark in
//                        Button(action: {
//                            viewModel.selectLandmark(landmark)
//                            showSearchResults = false
//                        }) {
//                            VStack(alignment: .leading) {
//                                Text(landmark.name)
//                                    .font(.headline)
//                                Text(landmark.title)
//                                    .font(.subheadline)
//                            }
//                        }
//                    }
//                    .frame(height: 200)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .padding()
//                }
//            }
//        }
//        .onAppear {
//            viewModel.checkLocationAuthorization()
//        }
//        .alert(isPresented: $viewModel.showError) {
//            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//}
//
//class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.3320, longitude: -122.0312),
//        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//    )
//    @Published var landmarks: [Landmark] = []
//    @Published var showError = false
//    @Published var errorMessage = ""
//
//    private var searchCompleter = MKLocalSearchCompleter()
//    private var locationManager: CLLocationManager?
//    private var searchCache = [String: [Landmark]]()
//    private var cancellables = Set<AnyCancellable>()
//    private var searchSubject = PassthroughSubject<String, Never>()
//
//    override init() {
//        super.init()
//        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .pointOfInterest
//        
//        setupLocationManager()
//        setupSearchDebounce()
//    }
//
//    private func setupLocationManager() {
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//    }
//
//    private func setupSearchDebounce() {
//        searchSubject
//            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { [weak self] searchText in
//                self?.performSearch(searchText)
//            }
//            .store(in: &cancellables)
//    }
//
//    func debouncedSearch(_ searchText: String) {
//        searchSubject.send(searchText)
//    }
//
//    private func performSearch(_ searchText: String) {
//        guard !searchText.isEmpty else {
//            landmarks = []
//            return
//        }
//
//        if let cachedResults = searchCache[searchText] {
//            landmarks = cachedResults
//            return
//        }
//
//        landmarks = [] // Clear previous results
//        searchCompleter.queryFragment = searchText
//    }
//
//    func checkLocationAuthorization() {
//        guard let locationManager = locationManager else { return }
//
//        switch locationManager.authorizationStatus {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            showError = true
//            errorMessage = "Location access is restricted. Please enable it in settings to use this feature."
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.startUpdatingLocation()
//        @unknown default:
//            break
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        
//        DispatchQueue.main.async {
//            self.region = MKCoordinateRegion(
//                center: location.coordinate,
//                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            )
//        }
//        
//        manager.stopUpdatingLocation()
//    }
//
//    func selectLandmark(_ landmark: Landmark) {
//        region = MKCoordinateRegion(
//            center: landmark.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
//    }
//}
//
//extension MapViewModel: MKLocalSearchCompleterDelegate {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = completer.queryFragment
//        searchRequest.region = region
//
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { [weak self] (response, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.showError = true
//                    self.errorMessage = "Search failed: \(error.localizedDescription)"
//                }
//                return
//            }
//            
//            guard let response = response else { return }
//            
//            let newLandmarks = response.mapItems.map { item in
//                Landmark(placemark: item.placemark, name: item.name ?? "", title: item.placemark.title ?? "")
//            }
//            
//            DispatchQueue.main.async {
//                self.landmarks = newLandmarks
//                self.searchCache[completer.queryFragment] = newLandmarks
//            }
//        }
//    }
//
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        DispatchQueue.main.async {
//            self.showError = true
//            self.errorMessage = "Search failed: \(error.localizedDescription)"
//        }
//    }
//}
//
//struct Landmark: Identifiable {
//    let id = UUID()
//    let placemark: MKPlacemark
//    let name: String
//    let title: String
//    
//    var coordinate: CLLocationCoordinate2D {
//        placemark.coordinate
//    }
//}
//
//struct MapSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSearchView()
//    }
//}
