//
//  Parker_UIApp.swift
//  Parker-UI
//
//  Created by 安德烈 on 2/19/25.
//

import SwiftUI

@main
struct Parker_UIApp: App {
    
    @State var model = ParkingSpotModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(model)
                .onAppear() {
                    model.getUserLocation()
                }
        }
    }
}
