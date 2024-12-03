import Foundation
import Combine

class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favorites: [String: Bool] = [:]

    private var cancellables = Set<AnyCancellable>()

    func fetchPlaces() {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/places/") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    throw URLError(.userAuthenticationRequired)
                }
                return output.data
            }
            .decode(type: [Place].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] places in
                self?.places = places
                places.forEach { place in
                    if self?.favorites[place.id] == nil {
                        self?.favorites[place.id] = false
                    }
                }
            }
            .store(in: &cancellables)
    }

    func addToFavorites(userId: String, placeId: String, token: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://eco-trip-bbhvbvmgsq-uc.a.run.app/favorplace/") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Authorization Header

        // 必須傳遞 UserId 和 PlaceId
        let requestBody: [String: String] = [
            "UserId": userId,
            "PlaceId": placeId
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            print("Request body: \(requestBody)")
        } catch {
            completion(false, "Failed to encode request body")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Invalid response")
                    return
                }

                if httpResponse.statusCode == 201 {
                    completion(true, nil) // 操作成功
                } else {
                    // 解析伺服器返回的錯誤訊息
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response body: \(responseString)")
                    }
                    completion(false, "Server error: HTTP \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }



}
