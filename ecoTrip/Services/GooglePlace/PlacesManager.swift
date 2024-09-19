//
//  PlacesManager.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/8.
//

import Foundation
import GooglePlaces
import GoogleMaps

class PlacesManager: ObservableObject {
    static let shared = PlacesManager()
    
    private init() {
        // 初始化 Google Places
        GMSPlacesClient.provideAPIKey("AIzaSyAQfZqoXkrngp_JfwCWqQoPHmIybQc2N6w")
    }
    
    func findNearbyPlaces(latitude: Double, longitude: Double, radius: Double, completion: @escaping ([Place]) -> Void) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let viewport = GMSCoordinateBounds(coordinate: center, coordinate: center)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.radius = radius
        
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: "", bounds: viewport, filter: filter) { (results, error) in
            guard let results = results, error == nil else {
                print("查找自動完成預測時出錯: \(error?.localizedDescription ?? "未知錯誤")")
                completion([])
                return
            }
            
            let places = results.compactMap { result -> Place? in
                return Place(id: result.placeID,
                             address: result.attributedPrimaryText.string,
                             image: "", // 您需要單獨獲取此信息
                             lat: "\(center.latitude)",
                             long: "\(center.longitude)",
                             lowCarbon: false, // 您需要單獨確定此信息
                             openingTime: "", // 您需要單獨獲取此信息
                             placename: result.attributedSecondaryText?.string ?? "",
                             rating: 0) // 您需要單獨獲取此信息
            }
            
            completion(places)
        }
    }
}
