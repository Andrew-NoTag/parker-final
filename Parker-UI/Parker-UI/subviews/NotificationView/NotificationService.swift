//
//  NotificationRow.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI

struct NotificationRow: View {
    var notification: Notification
    @State var showSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack{
                Text(notification.title)
                    .font(.headline)
                Spacer()
                Text(notification.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(notification.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }.onTapGesture {
            showSheet = true
        }.sheet(isPresented: $showSheet) {
            NotificationSheetView(notification: notification)
                .presentationDetents([.height(400), .medium, .large])
                .presentationDragIndicator(.automatic)
        }
        .font(.title).bold()
        
    }
}

struct NotificationSheetView: View {
    @State var notification: Notification
    var body: some View {
        VStack{
            Text(notification.title)
                .font(.largeTitle)
                .foregroundStyle(.primary)
                .bold()
                .padding(40)
            Text(notification.message)
                .font(.title)
                .foregroundStyle(.primary)
        }
    }
}


#Preview {
    NotificationSheetView(notification: Notification(title: "Placeholder", message: "placeholder", date: "00:00 AM"))
}



#Preview {
    NotificationRow(notification: Notification(title: "Placeholder", message: "placeholder", date: "00:00 AM"))
}
