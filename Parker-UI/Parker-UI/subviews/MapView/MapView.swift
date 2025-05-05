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
            case "restricted":
                return .yellow
            default:
                return .gray
            }
        }
    }

    private func canParkNow(for parkingSpot: ParkingSpot) -> Bool {
    guard let day = parkingSpot.day,
          let startTime = parkingSpot.start_time,
          let endTime = parkingSpot.end_time else {
        return true
    }

    let currentDate = Date()
    let calendar = Calendar.current

    // Get current day abbreviation
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    let currentDay = dateFormatter.string(from: currentDate)

    // Check if today is a restricted day
    guard currentDay == day else {
        return true
    }

    // Parse start and end time strings into components
    func timeStringToComponents(_ timeStr: String) -> DateComponents? {
        let parts = timeStr.split(separator: ":").map { Int($0) }
        guard parts.count == 3,
              let hour = parts[0], let minute = parts[1], let second = parts[2] else {
            return nil
        }
        return DateComponents(hour: hour, minute: minute, second: second)
    }

    guard let startComponents = timeStringToComponents(startTime),
          let endComponents = timeStringToComponents(endTime) else {
        return true
    }

    let nowComponents = calendar.dateComponents([.hour, .minute, .second], from: currentDate)

    // Convert all components to seconds since midnight
    func toSeconds(_ components: DateComponents) -> Int {
        return (components.hour ?? 0) * 3600 +
               (components.minute ?? 0) * 60 +
               (components.second ?? 0)
    }

    let nowSec = toSeconds(nowComponents)
    let startSec = toSeconds(startComponents)
    let endSec = toSeconds(endComponents)

    // Return false if we are in restricted time
    if nowSec >= startSec && nowSec <= endSec {
        return false
    }

    return true
}

}

#Preview {
    MapView().environment(ParkingSpotModel())
}
