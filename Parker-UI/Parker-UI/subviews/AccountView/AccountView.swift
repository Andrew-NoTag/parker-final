//
//  SearchView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI


struct AccountView: View {
    // Persistent storage
    @AppStorage("isSignedUp")  private var isSignedUp:  Bool   = false // account exists
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool   = false // session state
    @AppStorage("phoneNumber") private var phoneNumber: String = ""
    @AppStorage("passcode")    private var passcode:   String = ""
    @AppStorage("credits")     private var credits:    Int    = 0

    // Local state for auth forms
    @State private var authPhone:    String = ""
    @State private var authPasscode: String = ""
    @State private var showSignUp:   Bool   = false
    @State private var showLoginError: Bool = false
    @State private var showCreditsInfo = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                AccountScreen
            } else if showSignUp {
                SignUpForm
                    .navigationTitle("Create Account")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                LoginForm
                    .navigationTitle("Sign In")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Invalid credentials", isPresented: $showLoginError) {
            Button("OK", role: .cancel) { }
        }
    }

    // MARK: ‑ Login Form
    private var LoginForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 64))
                .padding(.top, 40)
                .foregroundColor(.accentColor)

            VStack(spacing: 16) {
                TextField("Phone Number", text: $authPhone)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
                SecureField("Passcode", text: $authPasscode)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Button {
                if authPhone == phoneNumber && authPasscode == passcode && isSignedUp {
                    isLoggedIn = true
                    authPhone = ""
                    authPasscode = ""
                } else {
                    showLoginError = true
                }
            } label: {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(authPhone.isEmpty || authPasscode.isEmpty ? Color.gray.opacity(0.4) : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(authPhone.isEmpty || authPasscode.isEmpty)
            .padding(.horizontal)

            Button {
                showSignUp = true
            } label: {
                Text("Need an account? Sign Up")
                    .font(.subheadline)
            }
            .padding(.top, 8)
            Spacer()
        }
    }

    // MARK: - Sign‑Up Form
    private var SignUpForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 64))
                .padding(.top, 40)
                .foregroundColor(.accentColor)

            VStack(spacing: 16) {
                TextField("Phone Number", text: $authPhone)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
                SecureField("Passcode", text: $authPasscode)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Button {
                phoneNumber = authPhone
                passcode    = authPasscode
                credits     = 0
                isSignedUp  = true
                isLoggedIn  = true
                showSignUp  = false
                authPhone = ""
                authPasscode = ""
            } label: {
                Text("Create Account")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(authPhone.isEmpty || authPasscode.isEmpty ? Color.gray.opacity(0.4) : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(authPhone.isEmpty || authPasscode.isEmpty)
            .padding(.horizontal)

            Button {
                showSignUp = false
            } label: {
                Text("Back to Sign In")
                    .font(.subheadline)
            }
            .padding(.top, 8)
            Spacer()
        }
    }

    // MARK: - Main Account Screen
    private var AccountScreen: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Big Credits Card
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(height: 150)
                    VStack(spacing: 8) {
                        Text("Credits")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        HStack(spacing: 6) {
                            Text("\(credits)")
                                .font(.system(size: 48, weight: .bold))
                            Button {
                                showCreditsInfo = true
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .alert("How Credits Work", isPresented: $showCreditsInfo) {
                    Button("Got it", role: .cancel) { }
                } message: {
                    Text("Each availability report rewards 50 credits. Users with 100+ credits can view others' availability reports.")
                }

                // Rest of settings list
                settingsList
            }
            .padding(.top)
        }
        .navigationTitle("My Account")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Settings List
    private var settingsList: some View {
        List {
            // Account details (phone)
            Section(header: Text("Account")) {
                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.accentColor)
                    Text("Phone")
                    Spacer()
                    Text(phoneNumber)
                        .foregroundColor(.secondary)
                }
            }

            // Security section
            Section(header: Text("Security")) {
                NavigationLink(destination: ChangePasscodeView()) {
                    Label("Change Passcode", systemImage: "key.fill")
                }
            }

            // Logout
            Section {
                Button(role: .destructive) {
                    logout()
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                        Spacer()
                    }
                }
            }
        }
        .frame(height: 350) // constrain list height so content scrolls nicely
        .listStyle(.insetGrouped)
    }

    // MARK: - Helpers
    private func logout() {
        isLoggedIn = false
        authPhone   = ""
        authPasscode = ""
    }
}

// MARK: - Deep Passcode View
struct ChangePasscodeView: View {
    @AppStorage("passcode") private var passcode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var showMismatchAlert = false

    var body: some View {
        Form {
            Section(header: Text("Enter New Passcode")) {
                SecureField("New Passcode", text: $newPasscode)
                SecureField("Confirm Passcode", text: $confirmPasscode)
            }
            Section {
                Button("Update Passcode") {
                    if newPasscode == confirmPasscode && !newPasscode.isEmpty {
                        passcode = newPasscode
                        newPasscode = ""
                        confirmPasscode = ""
                    } else {
                        showMismatchAlert = true
                    }
                }
                .disabled(newPasscode.isEmpty || confirmPasscode.isEmpty)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Change Passcode")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Passcodes do not match", isPresented: $showMismatchAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}


#Preview {
    AccountView().environment(ParkingSpotModel())
}
