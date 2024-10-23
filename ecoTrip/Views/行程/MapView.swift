import SwiftUI
import GoogleMaps

struct MapView: View {
    let stops: [Stop]

    var body: some View {
        GoogleMapView(stops: stops)
            .edgesIgnoringSafeArea(.all)
    }
}

struct GoogleMapView: UIViewRepresentable {
    var stops: [Stop]
    var geocoder = CLGeocoder()
    let apiKey = "AIzaSyAMncPb3INeUVKzl3gA8S0DRwgVUUvecwE"

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 25.0330, longitude: 121.5654, zoom: 10.0)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true

        // 第一步：先顯示所有 stop 的 pin
        addStopPins(mapView: mapView)
        
        // 第二步：獲取路線並在地圖上畫出來
        fetchDirections(mapView: mapView)

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        // 更新視圖時重新添加 stop pins
        addStopPins(mapView: mapView)
        
        // 再次獲取路線並畫出路線
        fetchDirections(mapView: mapView)
    }

    // 添加 stops 的 pin
    func addStopPins(mapView: GMSMapView) {
        let group = DispatchGroup()
        var bounds = GMSCoordinateBounds()

        for stop in stops {
            group.enter()
            geocoder.geocodeAddressString(stop.Address) { placemarks, error in
                defer { group.leave() }

                if let error = error {
                    print("Geocoding error for \(stop.Address): \(error.localizedDescription)")
                    return
                }

                guard let placemark = placemarks?.first, let location = placemark.location else {
                    print("No valid placemark found for \(stop.Address)")
                    return
                }

                DispatchQueue.main.async {
                    // Add the marker to the map
                    let marker = GMSMarker()
                    marker.position = location.coordinate
                    marker.title = stop.stopname
                    marker.map = mapView

                    // Update the bounds to include this coordinate
                    bounds = bounds.includingCoordinate(location.coordinate)
                }
            }
        }

        group.notify(queue: .main) {
            // Update the camera after all geocoding tasks have finished
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
            mapView.animate(with: update)
            print("All pins added and camera updated.")
        }
    }







    // 獲取路線並畫出多線段
    func fetchDirections(mapView: GMSMapView) {
        guard stops.count >= 2 else {
            print("Not enough stops to create a route.")
            return
        }

        // 取得起點和終點
        let origin = stops.first!.Address
        let destination = stops.last!.Address

        // 中途點是 stops 中除了第一和最後的點
        let waypoints = stops.dropFirst().dropLast().map { $0.Address }
        let waypointsStr = waypoints.joined(separator: "|")

        let urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&waypoints=optimize:true|\(waypointsStr)&key=\(apiKey)"

        guard let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching directions: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let routes = json["routes"] as? [[String: Any]],
                   let overviewPolyline = routes.first?["overview_polyline"] as? [String: Any],
                   let points = overviewPolyline["points"] as? String {
                    // 獲取到多線段後，在地圖上畫出來
                    DispatchQueue.main.async {
                        self.drawPolyline(mapView: mapView, encodedPath: points)
                    }
                } else {
                    print("Could not parse directions")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }

    // 畫出多線段
    func drawPolyline(mapView: GMSMapView, encodedPath: String) {
        if let path = GMSPath(fromEncodedPath: encodedPath) {
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 4.0
            polyline.strokeColor = .blue
            polyline.map = mapView

            var bounds = GMSCoordinateBounds()
            for index in 0..<path.count() {
                bounds = bounds.includingCoordinate(path.coordinate(at: index))
            }

            let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
            mapView.animate(with: update)
        } else {
            print("Unable to decode polyline")
        }
    }
}

