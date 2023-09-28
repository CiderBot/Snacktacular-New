//
//  LoginView.swift
//  Snacktacular
//
//  Created by Steven Yung on 9/26/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {    // use to tab between textfields
        case email, password
    }
    @FocusState private var focusField: Field?
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    // change from online lesson, for some reason, the path code was not working, using the bool instead
    @State private var loginSuccess = false
    
    var body: some View {
        NavigationStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Group {
                TextField("E-Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) {
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never) // probably not needed
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) {
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray .opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Login")
                }
                .padding(.leading)
            }
            .disabled(buttonDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $loginSuccess) {
                SpotListView()
            }
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear() {
            // if login, skip login screen
            if Auth.auth().currentUser != nil {
                print("🪵 Login Success!")
                loginSuccess = true
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { Result, error in
            if let error = error { // signup error occur
                print("😡 SIGN UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN UP ERROR: \(error.localizedDescription))"
                showAlert = true
            } else {
                print("🙂 Registration Success!")
                loginSuccess = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in
            if let error = error { // signup error occur
                print("😡 LOG IN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("🪵⬅️ Login Success!")
                loginSuccess = true
            }
        }
    }
    
    func enableButtons() {
        // very simple email and password validation, assuming min 6 characters in both email and password
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
}

#Preview {
    LoginView()
}
