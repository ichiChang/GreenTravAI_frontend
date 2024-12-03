import SwiftUI
import GoogleMaps

struct MapView: View {
    let stops: [Stop]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
                  GoogleMapView(stops: stops)
                      .edgesIgnoringSafeArea(.all)
                  VStack {
                      dismissButton
                      Spacer()
                  }
              }
          }
    var dismissButton: some View {
            Button(action: {
                dismiss()
            }) {
                HStack {
              
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .bold()
                        .foregroundColor(Color(hex: "838383"))
                        .background(Circle().foregroundColor(Color(hex: "F5F5F5")).frame(width: 40, height: 40))
                    Spacer()
                }
            }
            .padding(40)
        }
    

}

struct GoogleMapView: UIViewRepresentable {
    var stops: [Stop]
    var geocoder = CLGeocoder()
    let apiKey = "AIzaSyAMncPb3INeUVKzl3gA8S0DRwgVUUvecwE"

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        
        // 獲取路線
        fetchDirections(mapView: mapView)

        // 顯示所有 stop 的 pin
        addStopPins(mapView: mapView)
        

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        // 更新視圖時重新添加 stop pins
        addStopPins(mapView: mapView)
        
        // 再次獲取路線並畫出路線
        fetchDirections(mapView: mapView)
    }
    func imageWithText(text: String) -> UIImage {
        let font = UIFont.boldSystemFont(ofSize: 14)
        let textAttributes = [NSAttributedString.Key.font: font]
        
        // 根據text的長度調整邊界數值
        let boundingRect = text.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude),
                                             options: .usesLineFragmentOrigin,
                                             attributes: textAttributes,
                                             context: nil)
        
        // 設定label寬度和高度
        let labelWidth = max(100, ceil(boundingRect.width) + 15)
        let labelHeight = ceil(boundingRect.height) + 15

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
        label.backgroundColor = .white
        label.textColor = .black
        label.font = font
        label.textAlignment = .center
        label.text = text
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor

        // 生成image
        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, UIScreen.main.scale)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    
    //自定義標記圖像
    func createCompositeImage(baseImage: UIImage, overlayImage: UIImage, spacing: CGFloat) -> UIImage {

        let width = max(baseImage.size.width, overlayImage.size.width)
        let height = baseImage.size.height + overlayImage.size.height + spacing

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        
        let baseImageArea = CGRect(x: (width - baseImage.size.width) / 2, y: overlayImage.size.height + spacing, width: baseImage.size.width, height: baseImage.size.height)
           let overlayImageArea = CGRect(x: (width - overlayImage.size.width) / 2, y: 0, width: overlayImage.size.width, height: overlayImage.size.height)


        baseImage.draw(in: baseImageArea)
        overlayImage.draw(in: overlayImageArea)

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return combinedImage!
    }

    // 添加 stops 的 pin
    func addStopPins(mapView: GMSMapView) {
        var bounds = GMSCoordinateBounds()
        let redMarkerImage = GMSMarker.markerImage(with: .red)

        for (index, stop) in stops.enumerated() {
            let latitude = stop.coordinates[1]
            let longitude = stop.coordinates[0]
            let customIcon = imageWithText(text: "\(index + 1). \(stop.stopname)")
            let compositeIcon = createCompositeImage(baseImage: redMarkerImage, overlayImage: customIcon, spacing: 5)

            // Add the marker to the map
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.map = mapView
            marker.icon = compositeIcon

            // Update the bounds to include this coordinate
            bounds = bounds.includingCoordinate(marker.position)
        }

        // Update the camera after all markers have been added
        if stops.count == 1 {
            // For a single stop, set the camera to that stop's location with a zoom level
            let singleStop = stops.first!
            let latitude = singleStop.coordinates[1]
            let longitude = singleStop.coordinates[0]
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
            mapView.camera = camera
        } else {
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
            mapView.moveCamera(update)
        }
        print("All pins added and camera updated.")
    }



    // 獲取路線
    func fetchDirections(mapView: GMSMapView) {
        guard stops.count >= 2 else {
            print("Only one stop available. Adding pin without route.")
            DispatchQueue.main.async {
                self.addStopPins(mapView: mapView) // 只有一個 stop 時只添加 pin
            }
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

