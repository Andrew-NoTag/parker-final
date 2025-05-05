import SwiftUI
import CoreLocation
import MapKit

//--------------------------------------------------------------
//  ParkingListView.swift  ✅ Tappable rows now work for BOTH
//  real‑time data and demo data (lat/long only).
//--------------------------------------------------------------

struct ListView: View {
    // Shared model supplies fetched spots + GPS coords
    @Environment(ParkingSpotModel.self) private var model
    // Selected spot triggers the bottom sheet
    @State private var selectedSpot: ParkingSpot?
    @State private var isLoading = true   // while we fetch

    // Combine real spots (when available) or demo fallback
    private var displaySpots: [ParkingSpot] {
        model.parkingSpots.isEmpty ? demoSpots : model.parkingSpots
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    // Spinner first time in
                    ProgressView("Fetching nearby spots…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Single List for BOTH real + demo spots.
                    List(displaySpots, id: \.id) { spot in
                        // Wrap each row in a Button so it’s tappable.
                        Button { selectedSpot = spot } label: { row(for: spot) }
                            .buttonStyle(.plain)
                    }
                    .listStyle(.insetGrouped)
                    // Overlay note only if we’re showing demo entries.
                }
            }
            .navigationTitle("Nearby Spots")
            // Fetch once view appears (async)
            .task { await fetchSpots() }
            // Detail sheet for whichever spot was tapped
            .sheet(item: $selectedSpot) { spot in
                SpotDetailSheet(spot: spot)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    // MARK: - Async fetch helper
    private func fetchSpots() async {
        model.getUserLocation()                 // refresh GPS
        try? await Task.sleep(nanoseconds: 600_000_000) // ~0.6s
        await MainActor.run {
            model.getParkingSpots()             // hit backend
            isLoading = false                   // stop spinner
        }
    }

    // MARK: - Row UI
    private func row(for spot: ParkingSpot) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "parkingsign.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .saturation(0.25)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(spot.street_name)
//                Text("Lat: \(String(format: "%.4f", spot.latitude))")
//                Text("Lon: \(String(format: "%.4f", spot.longitude))")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 6)
    }

    // MARK: - Demo fallback (lat & long only)
    private var demoSpots: [ParkingSpot] {
        [
            ParkingSpot(id: "DEMO1", latitude: 40.6940, longitude: -73.9860, street_name: "Demo Street3", status: "HAHA"),
            ParkingSpot(id: "DEMO2", latitude: 40.6950, longitude: -73.9870, street_name: "Demo Street 5", status: "HEY")
        ]
    }
}

//--------------------------------------------------------------
//  SpotDetailSheet.swift  —  Larger sheet for each spot
//--------------------------------------------------------------

struct SpotDetailSheet: View {
    let spot: ParkingSpot
    // Native openURL environment value to launch Maps link
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 24) {
            Capsule() // grab bar
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
            header
            infoBox
                .padding(.horizontal)
            mapsButton
                .padding(.horizontal)
            Spacer()
        }
    }

    // Icon + title section
    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            Text("Parking Spot")
                .font(.title2.bold())
        }
    }

    // info bubble
    private var infoBox: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow("Street Name", value: spot.street_name)
            if spot.start_time != nil {
                infoRow("Start Time", value: spot.start_time!)
            }
            if spot.end_time != nil {
                infoRow("End Time", value: spot.end_time!)
            }
            infoRow("Status", value: spot.status)
            infoRow("Latitude", value: String(format: "%.5f", spot.latitude))
            infoRow("Longitude", value: String(format: "%.5f", spot.longitude))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }

    // One info row inside the bubble
    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
    }

    // Large button that opens Apple Maps
    private var mapsButton: some View {
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
    }

    private func openInMaps() {
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(spot.latitude),\(spot.longitude)&dirflg=d") else { return }
        openURL(url)
    }
}

//--------------------------------------------------------------
//  Preview with minimal mock data (lat/long only)
//--------------------------------------------------------------

#Preview {
    struct PreviewWrapper: View {
        @State private var model = ParkingSpotModel()
        var body: some View {
            NavigationStack { ListView().environment(model) }
                .onAppear {
                    model.parkingSpots = [
                        ParkingSpot(id: "P1", latitude: 40.6940, longitude: -73.9860, street_name: "demo Street", status: "commercial Vehicle Only"),
                        ParkingSpot(id: "P2", latitude: 40.6950, longitude: -73.9870, street_name: "demo Street2", status: "restricted")
                    ]
                    model.currentUserLocation = CLLocationCoordinate2D(latitude: 40.6935, longitude: -73.9859)
                }
        }
    }
    return PreviewWrapper()
}
