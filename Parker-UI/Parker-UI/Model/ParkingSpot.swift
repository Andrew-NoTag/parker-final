//
//  ParkingSpot.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation

struct ParkingSpot: Identifiable, Decodable {
    var id: String
    var latitude: Double // User latitude
    var longitude: Double // User longitude
    var street_name: String // Street name
    var status: String // Status
    var day: String? // Optional: “Monday” or “Tuesday” etc
    var start_time: String? // Optional: “HH:MM”
    var end_time: String? // Optional: “HH:MM”
}
