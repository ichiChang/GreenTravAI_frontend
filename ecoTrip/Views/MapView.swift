//
//  MapView.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/9/8.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: -33.8683, longitude: 151.2086, zoom: 6)
        let mapView = GMSMapView(options:options)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
