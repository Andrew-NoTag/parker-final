//
//  SwiftUIView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(ParkingSpotModel.self) var model
    
    var body: some View {
        Map() {
            ForEach(model.parkingSpots, id:\.id) { p in
                Marker(p.street_name, coordinate: CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude))
                    .tint(markerColor(for: p))
                    .tag(p.id)
            }
        }
        .onAppear() {
            model.getParkingSpots()
        }
    }

    private func markerColor(for parkingSpot: ParkingSpot) -> Color {
        // Check if parking is allowed based on day and time
        if !canParkNow(for: parkingSpot) {
            return .red // Red if parking is not allowed
        } else {
            // Otherwise, use the status
            switch parkingSpot.status {
            case "available":
                return .green
            default:
                return .gray
            }
        }
    }

    private func canParkNow(for parkingSpot: ParkingSpot) -> Bool {
        guard let day = parkingSpot.day,
              let startTime = parkingSpot.start_time,
              let endTime = parkingSpot.end_time else {
            return true // Allow parking if any restriction data is missing
        }

        let currentDate = Date()
        let calendar = Calendar.current

        // Get the current day of the week in three-letter format (e.g., "Mon", "Tue")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Abbreviated day format
        let currentDay = dateFormatter.string(from: currentDate)

        // Check if the current day matches the restriction day
        guard currentDay == day else {
            return true // Allow parking if it's not the restricted day
        }

        // Parse start and end times (format: HH:mm:ss)
        dateFormatter.dateFormat = "HH:mm:ss"

        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return true // Allow parking if time parsing fails
        }

        // Get the current time
        let currentTime = calendar.dateComponents([.hour, .minute, .second], from: currentDate)
        let current = dateFormatter.date(from: "\(currentTime.hour!):\(currentTime.minute!):\(currentTime.second!)")!

        if current < start || current > end {
            return false // Return false if parking is outside the allowed range
        }

        return true // Allow parking if the current time is within the allowed range
    }
}

#Preview {
    MapView().environment(ParkingSpotModel())
}
