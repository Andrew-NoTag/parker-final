//
//  SwiftUIView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI
import MapKit
struct MapView: View {
    
    var body: some View {
        Map() {
            Marker("Meter", coordinate: CLLocationCoordinate2D(latitude: 40.6935, longitude: -73.9859))
        }
    }
    
}

#Preview {
    MapView()
}
