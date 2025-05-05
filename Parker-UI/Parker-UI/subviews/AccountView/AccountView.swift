

import SwiftUI

//--------------------------------------------------------------
//  AccountView.swift
//  Uses DataService.login & DataService.signUp for auth.
//--------------------------------------------------------------

struct AccountView: View {
    // Persisted user session / profile
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("phoneNumber") private var phoneNumber: String = ""
    @AppStorage("credits")     private var credits: Int = 0

    // Local state for auth forms
    @State private var inputPhone: String = ""
    @State private var inputPass:  String = ""
    @State private var showSignUp = false

    // Feedback / loading
    @State private var isSubmitting = false
    @State private var alertMessage = ""
    
    @State private var showCreditsInfo = false

    private let service = DataService()  // networking layer
    
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                accountScreen
            } else if showSignUp {
                signUpForm
            } else {
                loginForm
            }
        }
        .alert(alertMessage, isPresented: $showAlert) { Button("OK", role: .cancel) { } }
        .alert("How Credits Work", isPresented: $showCreditsInfo) {
            Button("Got it", role: .cancel) { }
        } message: {
            Text("Each availability report rewards 50 credits. Users with 100+ credits can view others' availability reports.")
        }
        
    }

    //----------------------------------------------------------
    // MARK: - Login Form
    //----------------------------------------------------------
    private var loginForm: some View {
        formContainer(title: "Sign In", systemImage: "person.crop.circle") {
            authFields
            authButton(label: "Sign In") {
                await performLogin()
            }
            Button("Need an account? Sign Up") { showSignUp = true }
                .font(.subheadline)
        }
    }

    //----------------------------------------------------------
    // MARK: - Sign‑Up Form
    //----------------------------------------------------------
    private var signUpForm: some View {
        formContainer(title: "Create Account", systemImage: "person.crop.circle.badge.plus") {
            authFields
            authButton(label: "Create Account") {
                await performSignUp()
            }
            Button("Back to Sign In") { showSignUp = false }
                .font(.subheadline)
        }
    }

    //----------------------------------------------------------
    // MARK: - Reusable auth fields & button
    //----------------------------------------------------------
    private var authFields: some View {
        VStack(spacing: 16) {
            TextField("Phone Number", text: $inputPhone)
                .keyboardType(.phonePad)
                .textFieldStyle(.roundedBorder)
            SecureField("Passcode", text: $inputPass)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func authButton(label: String, action: @escaping () async -> Void) -> some View {
        Button {
            Task { await action() }
        } label: {
            if isSubmitting {
                ProgressView().frame(maxWidth: .infinity).padding()
            } else {
                Text(label)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .background(inputPhone.isEmpty || inputPass.isEmpty || isSubmitting ? Color.gray.opacity(0.4) : Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(12)
        .disabled(inputPhone.isEmpty || inputPass.isEmpty || isSubmitting)
        .padding(.horizontal)
    }

    //----------------------------------------------------------
    // MARK: - Account screen
    //----------------------------------------------------------
    var accountScreen: some View {
    VStack(spacing: 24) {
        Text("My Account")
            .font(.largeTitle)
            .foregroundColor(.black)
            .bold()
        Rectangle().foregroundStyle(.white)
            .frame(width: 10,height: 1)
        // Big credits card
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.accentColor.opacity(0.15))
            .frame(height: 150)
            .overlay(
                VStack {
                    HStack {
                        Text("Credits").font(.headline).foregroundColor(.accentColor)
                        Button {
                            showAlert = true
                            
                        } label:{
                            Image(systemName: "questionmark.circle").font(.title3).foregroundColor(.accentColor)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("How Credits Work"),
                                message: Text("Each report of availabilities gives you 50 credits. Only users with 100 or more credits can see other users' reports."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    Text("\(credits)").font(.system(size: 48, weight: .bold))
                }
            )
            .padding(.horizontal)

        List {
            Section(header: Text("Account")) {
                HStack {
                    Image(systemName: "phone").foregroundColor(.accentColor)
                    Text("Phone")
                    Spacer()
                    Text(phoneNumber).foregroundColor(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        
        List {
            Section {
                Button(role: .destructive) { logout() } label: {
                    HStack { Spacer(); Text("Log Out"); Spacer() }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    .navigationTitle("My Account")
    .navigationBarTitleDisplayMode(.inline)
}

    //----------------------------------------------------------
    // MARK: - Network calls
    //----------------------------------------------------------
    private func performLogin() async {
        isSubmitting = true
        do {
            let resp = try await service.login(phone: inputPhone, passcode: inputPass)
            guard resp.success else { throw URLError(.userAuthenticationRequired) }
            credits = resp.credits ?? credits
            phoneNumber = inputPhone
            isLoggedIn = true
            clearFields()
        } catch {
            alertMessage = "Login failed: \(error.localizedDescription)"
        }
        isSubmitting = false
    }

    private func performSignUp() async {
        isSubmitting = true
        do {
            let resp = try await service.signUp(phone: inputPhone, passcode: inputPass)
            guard resp.success else { throw URLError(.badServerResponse) }
            credits = resp.credits ?? 0
            phoneNumber = inputPhone
            isLoggedIn = true
            showSignUp = false
            clearFields()
        } catch {
            alertMessage = "Sign‑Up failed: \(error.localizedDescription)"
        }
        isSubmitting = false
    }

    private func clearFields() {
        inputPhone = ""; inputPass = ""
    }

    private func logout() {
        isLoggedIn = false
        clearFields()
    }

    //----------------------------------------------------------
    // MARK: - Reusable form container with icon
    //----------------------------------------------------------
    @ViewBuilder
    private func formContainer(title: String, systemImage: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(spacing: 24) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .padding(.top, 40)
                .foregroundColor(.accentColor)
            content()
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//--------------------------------------------------------------
//  Preview
//--------------------------------------------------------------

#Preview {
    AccountView()
}

#Preview {
    AccountView().accountScreen
}
