//
//  NotificationView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI

struct NotificationsView: View {
    @State var notifications: [Notification] = []
    var notificationDataServiceFake = NotificationDataServiceFake()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recent Notifications")) {
                    ForEach(notifications) { n in
                        NotificationRow(notification: n)
                    }
                }
            }
            .onAppear() {
                notifications = notificationDataServiceFake.getNofitications()
            }
            .navigationTitle("Notifications")
        }
    }
}

#Preview {
    NotificationsView()
}
