//
//  DataService.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation
import CoreLocation

struct DataService {
    
    func parkingSpotSearch(userLocation: CLLocationCoordinate2D?) async -> [ParkingSpot] {
        
        //default lat long
        var lat = 32.6514
        var long = -161.4333
        
        if let userLocation = userLocation {
            lat = userLocation.latitude
            long = userLocation.longitude
        }
        
        var endpointUrlString = "https://placeholder/search?latitude=\(lat)&longitude=\(long)"
        
        //create URL
        if let url = URL(string: endpointUrlString) {
            
            //create request
            var request = URLRequest(url: url)
            
            //send request
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                //parse the JSON
                let decoder = JSONDecoder()
                let result = try decoder.decode(ParkingSpotSearch.self, from: data)
                
                return result.parkingSpots
            }
            catch {
                print("Failed to fetch data")
                return []
            }
        }
        
        return [ParkingSpot]()
        
    }
    
    
}



