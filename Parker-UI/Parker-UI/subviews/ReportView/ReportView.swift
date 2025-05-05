//
//  AccountView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI
extension ParkingSpotModel: ObservableObject {}

struct ReportView: View {
    @StateObject private var model = ParkingSpotModel()
    @State private var isReporting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            if model.currentUserLocation == nil {
                ProgressView("Fetching location...")
                    .onAppear { model.getUserLocation() }
            } else {
                Button(action: reportAvailability) {
                    HStack {
                        if isReporting {
                            ProgressView()
                        }
                        Text(isReporting ? "Reporting..." : "Report Spot Available Near You")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(isReporting ? 0.5 : 1))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(isReporting)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Report Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func reportAvailability() {
        guard let coords = model.currentUserLocation else { return }
        isReporting = true
        // Simple networking call; replace with your DataService if needed
        let url = URL(string: "https://api.yourbackend.com/parking/report")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "latitude": coords.latitude,
            "longitude": coords.longitude,
            "available": true
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isReporting = false
                if let error = error {
                    alertMessage = "Failed: \(error.localizedDescription)"
                } else {
                    alertMessage = "Report submitted successfully!"
                }
                showAlert = true
            }
        }.resume()
    }
}
//// MARK: - Preview
//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}

#Preview {
    ReportView()
}
