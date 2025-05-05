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
                Marker("Spot", coordinate: CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude))
                    .tag(p.id)
                
            }
            
        }
        .onAppear(){
            model.getParkingSpots()
        }
    }
    
}

#Preview {
    MapView().environment(ParkingSpotModel())
}
