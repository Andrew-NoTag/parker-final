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
                    // "map" is the SF Symbol icon name here
                    Image(systemName: "map")
                    Text("Home")
                }.shadow(radius: 10)
                .tag(0)
            
            // 2) Search Tab
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .shadow(radius: 20)
                    Text("Search")
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
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
                .tag(3)
        }
    }
}


#Preview {
    MainView()
}
