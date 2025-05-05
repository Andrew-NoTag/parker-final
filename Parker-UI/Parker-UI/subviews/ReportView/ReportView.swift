import SwiftUI
import CoreLocation

/// View that lets a user crowd‑report an open parking spot at their current GPS position.
/// Requires `ParkingSpotModel` in the environment and `DataService.reportOpenSpot()` async API.
struct ReportView: View {
    @Environment(ParkingSpotModel.self) private var model
    @State private var isReporting = false
    @State private var showAlert   = false
    @State private var alertTitle  = ""
    @State private var alertMsg    = ""

    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "mappin.circle")
                .font(.system(size: 72))
                .foregroundColor(.accentColor)

            Text("Help fellow drivers by reporting an available spot near you.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                reportSpot()
            } label: {
                HStack {
                    if isReporting { ProgressView() }
                    Text(isReporting ? "Reporting…" : "Report Spot Available")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isReporting || model.currentUserLocation == nil ? Color.gray.opacity(0.4) : Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(isReporting || model.currentUserLocation == nil)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 60)
        .navigationTitle("Report Availability")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMsg)
        }
        .onAppear {
            // ensure we have a fresh location
            model.getUserLocation()
        }
    }

    // MARK: - Helpers
    private func reportSpot() {
        guard let coord = model.currentUserLocation else {
            alertTitle = "Location Unavailable"
            alertMsg   = "We couldn't determine your position. Please enable location services and try again."
            showAlert  = true
            return
        }

        isReporting = true
        Task {
            do {
                try await model.service.reportOpenSpot(latitude: coord.latitude, longitude: coord.longitude)
                // Optional: model.earnCredits() if you add such a method
                alertTitle = "Thank You!"
                alertMsg   = "Your report has been submitted."
            } catch {
                alertTitle = "Submission Failed"
                alertMsg   = error.localizedDescription
            }
            isReporting = false
            showAlert = true
        }
    }
}


#Preview {
    ReportView().environment(ParkingSpotModel())
}
