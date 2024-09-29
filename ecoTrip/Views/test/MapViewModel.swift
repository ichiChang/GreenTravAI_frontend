//
//  MapViewModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/29.
//

import Foundation
import GooglePlaces
import CoreLocation
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchResults: [PlaceModel] = []
    @Published var selectedPlace: PlaceModel?
    @Published var userLocationAuthorized = false
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var showingSearchResults = false
    
    private var placesClient: GMSPlacesClient!
    private var locationManager: CLLocationManager!
    var locationUpdateHandler: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        placesClient = GMSPlacesClient.shared()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            userLocationAuthorized = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            userLocationAuthorized = false
            print("Location access denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        userLocation = location
        locationUpdateHandler?(location)
        locationManager.stopUpdatingLocation() // Stop after getting the first location
    }

    func searchPlaces(query: String) {
        let token = GMSAutocompleteSessionToken.init()
        placesClient.findAutocompletePredictions(fromQuery: query, filter: nil, sessionToken: token) { (results, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.searchResults = results?.compactMap { result in
                PlaceModel(id: result.placeID, name: result.attributedPrimaryText.string, address: result.attributedSecondaryText?.string ?? "")
            } ?? []
        }
    }
    
    func selectPlace(_ place: PlaceModel) {
        placesClient.fetchPlace(fromPlaceID: place.id, placeFields: [.coordinate, .rating, .website, .photos], sessionToken: nil) { (gmsPlace, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let gmsPlace = gmsPlace {
                DispatchQueue.main.async {
                    var placeImage: Image? = nil // 用於 SwiftUI 的 Image

                    // 如果有圖片，下載第一張圖片
                    if let photoMetadata = gmsPlace.photos?.first {
                        self.placesClient.loadPlacePhoto(photoMetadata) { (photo: UIImage?, error: Error?) in
                            if let error = error {
                                print("Error loading photo: \(error.localizedDescription)")
                                return
                            }
                            
                            if let photo = photo {
                                placeImage = Image(uiImage: photo)
                            }

                            // 更新 selectedPlace 包含圖片
                            DispatchQueue.main.async {
                                self.selectedPlace = PlaceModel(
                                    id: place.id,
                                    name: place.name,
                                    address: place.address,
                                    coordinate: gmsPlace.coordinate,
                                    website: gmsPlace.website?.absoluteString,
                                    rating: gmsPlace.rating,
                                    image: placeImage
                                )
                                self.showingSearchResults = false
                            }
                        }
                    } else {
                        // 沒有圖片的情況下直接更新 selectedPlace
                        self.selectedPlace = PlaceModel(
                            id: place.id,
                            name: place.name,
                            address: place.address,
                            coordinate: gmsPlace.coordinate,
                            website: gmsPlace.website?.absoluteString,
                            rating: gmsPlace.rating,
                            image: nil // 沒有圖片的情況
                        )
                        self.showingSearchResults = false
                    }
                }
            }
        }
    }
}
