import SwiftUI
import GoogleMaps

struct MapView: View {
    let stops: [Stop]

    var body: some View {
        GoogleMapView(stops: stops)
            .edgesIgnoringSafeArea(.all) // 讓地圖填滿整個安全區域
    }
}

struct GoogleMapView: UIViewRepresentable {
    var stops: [Stop]
    var geocoder = CLGeocoder()

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 25.0330, longitude: 121.5654, zoom: 10.0)  // 設置初始攝像頭位置
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        geocodeAddresses(mapView: mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()  // 清除現有的標記
        geocodeAddresses(mapView: mapView)  // 重新編碼並添加標記
    }

    private func geocodeAddresses(mapView: GMSMapView) {
        let group = DispatchGroup()
        var bounds = GMSCoordinateBounds()

        for stop in stops {
            group.enter()
            geocoder.geocodeAddressString(stop.Address) { placemarks, error in
                defer { group.leave() }  // 確保每次進入都有對應的離開

                if let placemark = placemarks?.first, let location = placemark.location {
                    let marker = GMSMarker()
                    marker.position = location.coordinate
                    marker.title = stop.stopname
                    marker.map = mapView
                    bounds = bounds.includingCoordinate(marker.position)
                    print("Added marker for \(stop.stopname) at \(location.coordinate)")
                } else {
                    print("Geocoding failed for address: \(stop.Address) with error: \(String(describing: error))")
                }
            }
        }

        group.notify(queue: .main) {
            if bounds.isValid {  // 確認bounds是有效的
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)  // 添加足夠的padding
                mapView.animate(with: update)
                print("Camera updated to fit all markers.")
            } else {
                print("No valid bounds to fit camera.")
            }
        }
    }
}
