//
//  ParkingSpot.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 5/4/25.
//

import Foundation

struct ParkingSpot: Identifiable, Decodable{
    let id = UUID()
    var latitude: String //User latitude
    var longitude: String //User longitude
    var type: String  //“meter” or “street”
    var start_time: String  //“YYYY-MM-DD HH:MM”
    var end_time: String   //“YYYY-MM-DD HH:MM”
    var ifReported: Bool   //If there’s a reporting within 24 hr
    var ifAvailable: Bool // True if the last report reports empty,  False if reproted occupied
    var lastReportedAt: String   //“YYYY-MM-DD HH:MM”
}
