//
//  AccountView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI

struct AccountView: View {
    @State private var username: String = "Gerald Zhaoo"
    @State private var email: String = "geraldzhao@example.com"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 1) Profile Image
                ZStack(alignment: .bottomTrailing) {
                    Image("profilePlaceholder") // Replace with your own image asset
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    // Optional "edit photo" button overlay
                    Button(action: {
                        // Code to change photo or pick from gallery
                    }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .offset(x: -10, y: -10)
                }
                .padding(.top, 40)
                
                // 2) Form with user info
                Form {
                    Section(header: Text("Profile")) {
                        TextField("Username", text: $username)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            // Logout action here
                            // e.g., clear tokens, navigate to a login screen, etc.
                        } label: {
                            Text("Log Out")
                        }
                    }
                }
                .scrollContentBackground(.hidden) // iOS 16+ hide default form background
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
}
