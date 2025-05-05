//
//  SearchView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI
import CoreLocation

struct ListView: View {
    @Environment(ParkingSpotModel.self) var model

    var body: some View {
        NavigationView {
            List {
                ForEach(model.parkingSpots, id: \.id) { spot in
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spot ID: \(spot.id ?? "Unknown")")
                                .font(.headline)
                            if let userLoc = model.currentUserLocation {
                                let start = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
                                let end = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
                                let distanceInMeters = start.distance(from: end)
                                Text(String(format: "%.0f meters away", distanceInMeters))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(String(format: "Lat: %.4f, Lon: %.4f", spot.latitude, spot.longitude))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Parking Spots")
            .onAppear {
                model.getUserLocation()
            }
        }
    }
}


#Preview {
    ListView().environment(ParkingSpotModel())
}
