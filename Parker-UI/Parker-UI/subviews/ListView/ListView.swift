import SwiftUI
import CoreLocation
import MapKit


struct ParkingListView: View {
    @Environment(ParkingSpotModel.self) private var model
    // Selected spot triggers the .sheet when set
    @State private var selectedSpot: ParkingSpot?

    var body: some View {
        NavigationStack {
            List {
                ForEach(model.parkingSpots, id: \.id) { spot in
                    Button {
                        // Store selection -> presents sheet
                        selectedSpot = spot
                    } label: {
                        row(for: spot)
                    }
                    .buttonStyle(.plain)   // Removes the blue button tint
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Nearby Spots")
            .onAppear { model.getParkingSpots() }
            // Sheet pops up whenever selectedSpot becomes non‑nil
            .sheet(item: $selectedSpot) { spot in
                SpotDetailSheet(spot: spot)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    /// Builds a row for a given spot (icon + title + distance).
    private func row(for spot: ParkingSpot) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.title2)
                .foregroundColor(.accentColor)
            // VStack allows title & subtitle alignment
            VStack(alignment: .leading, spacing: 4) {
                Text("Spot ID: \(spot.id ?? "-")")
                    .font(.headline)
                if let distance = distanceString(to: spot) {
                    Text(distance)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 6)
    }

    /// Converts distance to user into a readable string.
    private func distanceString(to spot: ParkingSpot) -> String? {
        guard let user = model.currentUserLocation else { return nil }
        let userLoc  = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let spotLoc  = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let meters   = userLoc.distance(from: spotLoc)
        return meters < 1000 ?
            String(format: "%.0f m away", meters) :
            String(format: "%.1f km away", meters / 1000)
    }
}

//--------------------------------------------------------------
//  SpotDetailSheet.swift
//  Bottom‑sheet with info + Apple Maps button
//--------------------------------------------------------------

struct SpotDetailSheet: View {
    let spot: ParkingSpot
    // SwiftUI‑native openURL action for launching external links
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 24) {
            // Pull indicator for aesthetic
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 8)

            // Title area
            VStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                Text("Spot ID: \(spot.id ?? "-")")
                    .font(.title2.bold())
            }

            // Data bubble
            infoBubble
                .padding(.horizontal)

            // Navigation button
            Button {
                openInMaps()
            } label: {
                Label("Navigate in Maps", systemImage: "arrow.triangle.turn.up.right.diamond")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    /// Generates a rounded rectangle containing detail rows.
    private var infoBubble: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(label: "Latitude", value: String(format: "%.5f", spot.latitude))
            infoRow(label: "Longitude", value: String(format: "%.5f", spot.longitude))
//            if let type = spot.type {
//                infoRow(label: "Type", value: type.capitalized)
//            }
//            if let legal = spot.legalTimeToday {
//                infoRow(label: "Legal until", value: legal)
//            }
//            if let last = spot.lastReported {
//                infoRow(label: "Last reported", value: last)
//            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground)))
    }

    /// Builds a single row (label on left, value on right).
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }

    /// Opens Apple Maps with driving directions to the spot.
    private func openInMaps() {
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(spot.latitude),\(spot.longitude)&dirflg=d") else { return }
        openURL(url)
    }
}

//--------------------------------------------------------------
//  Preview – uses a mock spot & model for live canvas view
//--------------------------------------------------------------

#Preview {
    struct PreviewWrapper: View {
        @State private var model = ParkingSpotModel()
        var body: some View {
            NavigationStack {
                ParkingListView()
                    .environment(model)
            }
            .onAppear {
                // Inject a couple mock spots so the list isn't empty in preview
                model.parkingSpots = [
                    ParkingSpot(id: "ABC123", latitude: 40.694, longitude: -73.986),
                    ParkingSpot(id: "XYZ789", latitude: 40.695, longitude: -73.987)
                ]
                model.currentUserLocation = CLLocationCoordinate2D(latitude: 40.6935, longitude: -73.9859)
            }
        }
    }
    return PreviewWrapper()
}
