//
//  DataService.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation
import CoreLocation

struct DataService {
    
    func parkingSpotSearch(userLocation: CLLocationCoordinate2D?, limit: Int = 50) async -> [ParkingSpot] {
        // Default latitude and longitude
        var lat = 40.6935
        var long = -73.9859
        
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
                
                // Print the result for debugging
                print("Fetched Parking Spots: \(result)")
                
                return result
            } catch {
                print("Failed to fetch data: \(error)")
                return []
            }
        }
        
        return []
    }
    
    func reportOpenSpot(latitude: Double, longitude: Double) async throws {
            let endpoint = "http://localhost:8000/report-open-spot?latitude=\(latitude)&longitude=\(longitude)"
            guard let url = URL(string: endpoint) else { throw URLError(.badURL) }

            var request = URLRequest(url: url)
            request.httpMethod = "POST" // backend may still expect POST even though params are in URL

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpRes = response as? HTTPURLResponse, !(200...299).contains(httpRes.statusCode) {
                throw URLError(.badServerResponse)
            }
        }
    
}



