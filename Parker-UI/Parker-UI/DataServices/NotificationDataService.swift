//
//  DataService.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import Foundation
import SwiftUI

struct Notification: Identifiable {
    var id: UUID = UUID()
    var title: String
    var message: String
    var date: String // TODO: change Datatype to "Date" in the future
}

struct NotificationDataServiceFake {
    // Notification array
    var notifications: [Notification] = [Notification(title: "Parking Meter Avaliable",
                                                      message: "2 Parking Meters are Avaliable",
                                                      date: "1:45 PM"),
                                         Notification(title: "Parking Meter Update",
                                                      message: "Your meter is going to become unavaliable, move your car before 10AM",
                                                      date: "9:50 AM"),
                                         Notification(title: "Regional Update",
                                                      message: "Movie shoot all day today (Jay Street), parking is limited",
                                                      date: "6:00 AM"),
                                         Notification(title: "Parking Meter Avaliable", message: "3 Meters near you will be avaiable at 6:00 PM", date: "5:30 PM")]
    func getNofitications() -> [Notification] {
        return notifications
    }
}

