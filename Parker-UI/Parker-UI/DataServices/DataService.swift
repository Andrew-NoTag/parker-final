//
//  DataService.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation
import CoreLocation
import CryptoKit

struct DataService {
    
    func parkingSpotSearch(userLocation: CLLocationCoordinate2D?, limit: Int = 200) async -> [ParkingSpot] {
        // Default latitude and longitude
        var lat = 40.631485
        var long = -73.955025
        
        if let userLocation = userLocation {
            lat = userLocation.latitude
            long = userLocation.longitude
        }
        
        // Use the new backend endpoint
        let endpointUrlString = "http://localhost:8000/closest-parking-lots?latitude=\(lat)&longitude=\(long)&limit=\(limit)"
        
        // Create URL
        if let url = URL(string: endpointUrlString) {
            // Create request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Send request
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Parse the JSON
                let decoder = JSONDecoder()
                let result = try decoder.decode([ParkingSpot].self, from: data)
                
                return result
            } catch {
                print("Failed to fetch data: \(error)")
                return []
            }
        }
        
        return []
    }
    
    func reportOpenSpot(latitude: Double, longitude: Double) async throws {
        let endpoint = "http://localhost:8000/update-parking-status?latitude=\(latitude)&longitude=\(longitude)"
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpRes = response as? HTTPURLResponse, !(200...299).contains(httpRes.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    // MARK: - Auth Response ---------------------------------------------------------
        struct AuthResponse: Decodable {
            let success: Bool
            let credits: Int?
        }

        // MARK: - Sign‑Up & Login helpers ----------------------------------------------
        /// Convenience: hash passcode → SHA‑256 hex string
        private func hash(_ text: String) -> String {
            let hash = SHA256.hash(data: Data(text.utf8))
            return hash.map { String(format: "%02x", $0) }.joined()
        }

        /// Build a URLRequest for auth endpoints with hashed passcode in URL.
        private func authRequest(endpoint: String, phone: String, passcode: String) throws -> URLRequest {
            let passHash = hash(passcode)
            let phoneHash = hash(phone)
            let urlString = "http://localhost:8000/\(endpoint)?phone=\(phoneHash)&passhash=\(passHash)"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"   // use POST even though params are in URL
            return req
        }

        // MARK: - User sign‑up ----------------------------------------------------------
        func signUp(phone: String, passcode: String) async throws -> AuthResponse {
            let req = try authRequest(endpoint: "signup", phone: phone, passcode: passcode)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        }

        // MARK: - User login ------------------------------------------------------------
        func login(phone: String, passcode: String) async throws -> AuthResponse {
            let req = try authRequest(endpoint: "login", phone: phone, passcode: passcode)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        }
    
}



