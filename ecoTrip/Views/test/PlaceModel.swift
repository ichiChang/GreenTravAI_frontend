//
//  PlaceModel.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/29.
//


import Foundation
import CoreLocation
import SwiftUI

struct PlaceModel: Identifiable {
    let id: String
    let name: String
    let address: String
    var coordinate: CLLocationCoordinate2D?
    var distance: Double?
    var phoneNumber: String?
    var website: String?
    var rating: Float?
    var image: Image?
    var userRatingsTotal: Int?
}
