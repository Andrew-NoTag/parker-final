//
//  ContentView.swift
//  Parker-UI
//
//  Created by 安德烈 on 2/19/25.
//

import SwiftUI
import MapKit
import CoreLocation

/*
 struct ContentView display four different taps
 each tab's source code are in this same doc
 
 Created by Gerald Zhao on 3/2/25
 */
struct MainView: View { 
    var body: some View {
        TabView {
            // 1) Home Tab
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Home")
                }
                .tag(0)
            
            // 2) Search Tab
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .shadow(radius: 20)
                    Text("List")
                }
                .tag(1)
            
            // 3) Notifications Tab
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(2)
            
            // 4) Account Tab
            ReportView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Report a Spot")
                }
                .tag(3)
        }
    }
}


#Preview {
    MainView().environment(ParkingSpotModel())
}
