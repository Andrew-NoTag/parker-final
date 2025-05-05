//
//  ParkingSpotModel.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable
class ParkingSpotModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var parkingSpots = [ParkingSpot]()
    var selectedParkingSpot: ParkingSpot?
    
    var service = DataService()
    var locationManager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D?
    var locationAuthStatus: CLAuthorizationStatus = .notDetermined
    
    
    
    override init() {
        super.init()
        
        currentUserLocation = CLLocationCoordinate2D(latitude: 40.6935, longitude: -73.9859)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }
    
    func getParkingSpots() {
        Task {
            parkingSpots = await service.parkingSpotSearch(userLocation: currentUserLocation)
        }
    }
    
    func getUserLocation() {
        // Check if we have permission
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            
            currentUserLocation = nil
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        self.locationAuthStatus = manager.authorizationStatus
        
        // Detect if user allowed, then request location
        if manager.authorizationStatus == .authorizedWhenInUse {
            
            currentUserLocation = nil
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentUserLocation == nil {
            
            currentUserLocation = locations.last?.coordinate
            
            // Call parkingSpotSearch
            getParkingSpots()
        }
        
        manager.stopUpdatingLocation()
    }
    
}
