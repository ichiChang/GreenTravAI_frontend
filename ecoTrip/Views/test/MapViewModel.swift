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
    @Published var isLoading = false
    
    private var placesClient: GMSPlacesClient!
    private var locationManager: CLLocationManager!
    var locationUpdateHandler: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        placesClient = GMSPlacesClient.shared()
        setupLocationManager()
    }
    
    public func setupLocationManager() {
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
    func searchNearbyPlaces() {
        guard let userLocation = userLocation else {
            print("User location not available")
            return
        }
        
        isLoading = true
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        placesClient.currentPlace(callback: { (likelihoodList, error) in
            if let error = error {
                print("Error searching nearby places: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            guard let likelihoodList = likelihoodList else {
                print("No nearby places found")
                self.isLoading = false
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var tempResults: [PlaceModel] = []
            
            for likelihood in likelihoodList.likelihoods {
                let place = likelihood.place
                dispatchGroup.enter()
                
                self.fetchPlaceDetails(placeID: place.placeID!) { placeModel in
                    if let placeModel = placeModel, placeModel.userRatingsTotal ?? 0 > 50 {
                        tempResults.append(placeModel)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.searchResults = tempResults
                self.isLoading = false
            }
        })
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
        placesClient.fetchPlace(fromPlaceID: place.id, placeFields: [.coordinate, .rating, .website, .photos, .phoneNumber], sessionToken: nil) { (gmsPlace, error) in
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
                                    phoneNumber: gmsPlace.phoneNumber,
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
                            phoneNumber: gmsPlace.phoneNumber,
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
    private func fetchPlaceDetails(placeID: String, completion: @escaping (PlaceModel?) -> Void) {
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.formattedAddress, GMSPlaceProperty.coordinate, GMSPlaceProperty.rating, GMSPlaceProperty.userRatingsTotal, GMSPlaceProperty.website, GMSPlaceProperty.photos, GMSPlaceProperty.phoneNumber].map {$0.rawValue}
        let fetchPlaceReq = GMSFetchPlaceRequest(placeID: placeID, placeProperties: myProperties, sessionToken: nil)
        placesClient.fetchPlace(with: fetchPlaceReq, callback: {
            (gmsPlace: GMSPlace?, error: Error?) in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let gmsPlace = gmsPlace else {
                completion(nil)
                return
            }
            
            var placeModel = PlaceModel(
                id: placeID,
                name: gmsPlace.name ?? "",
                address: gmsPlace.formattedAddress ?? "",
                coordinate: gmsPlace.coordinate,
                phoneNumber: gmsPlace.phoneNumber,
                website: gmsPlace.website?.absoluteString,
                rating: gmsPlace.rating,
                userRatingsTotal: Int(gmsPlace.userRatingsTotal)
            )
            
            if let photoMetadata = gmsPlace.photos?.first {
                self.loadPlacePhoto(photoMetadata: photoMetadata) { image in
                    placeModel.image = image
                    completion(placeModel)
                }
            } else {
                completion(placeModel)
            }
        })
    }
    private func loadPlacePhoto(photoMetadata: GMSPlacePhotoMetadata, completion: @escaping (Image?) -> Void) {
        let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photoMetadata, maxSize: CGSizeMake(4800, 4800))
        placesClient.fetchPhoto(with: fetchPhotoRequest) { (photo: UIImage?, error: Error?) in
            if let error = error {
                print("Error loading photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let photo = photo {
                let image = Image(uiImage: photo)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}
