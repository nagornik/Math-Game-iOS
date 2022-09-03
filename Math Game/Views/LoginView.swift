//
//  LoginView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.08.2022.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    enum LoginMode: String {
        case signIn = "Log in"
        case register = "Create an account"
    }
    
    enum FocusedFields: Hashable {
        case email
        case password
        case name
    }
    
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    @FocusState var focus: FocusedFields?
    @State var isFocused = false
    
    @State var mode: LoginMode = .signIn
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var errorMessage: String?
    @State var showError = false
    
    var body: some View {
        
        VStack {
            
            Text(mode.rawValue)
                .font(.title2.bold())
                .foregroundColor(Color("text"))
            
            VStack {
                
                if mode == .register {
                    HStack {
                        Image(systemName: "person")
                            .font(.title2)
                            .frame(width: 30)
                        TextField("Name", text: $name)
                            .padding()
                            .focused($focus, equals: .name)
                    }
                    .padding(.leading)
                    .onTapGesture {
                        focus = .name
                    }
                    
                    Divider()
                    
                }
                
                HStack {
                    Image(systemName: "envelope")
                        .font(.title2)
                        .frame(width: 30)
                    TextField("Email", text: $email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .focused($focus, equals: .email)
                }
                .padding(.leading)
                .onTapGesture {
                    focus = .email
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "key")
                        .font(.title2)
                        .frame(width: 30)
                    SecureField("Password", text: $password)
                        .padding()
                        .focused($focus, equals: .password)
                }
                .padding(.leading)
                .onTapGesture {
                    focus = .password
                }
                
            }
            .padding()
            .background(.ultraThinMaterial)
            .foregroundColor(Color("text"))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            
            HStack(spacing: 4.0) {
                Text(mode == .register ? "Already have an account?" : "Don't have an account?")
                Text(mode == .register ? "Log in" : "Sign up")
                    .bold()
            }
            .font(.caption)
            .foregroundColor(Color("text"))
            .onTapGesture {
                if mode == .register {
                    mode = .signIn
                } else {
                    mode = .register
                }
            }
            
            TextButton(text: mode == .register ? "Sign up" : "Log in", size: 24)
                .padding()
                .onTapGesture {
                    loginOrRegisterOrNextField()
                }
                .disabled(logic.isLoading)
                .opacity(logic.isLoading ? 0.5 : 1)
                .animation(.spring(), value: logic.isLoading)
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            focus = nil
        }
        .alert("Oops... Something went wrong", isPresented: $showError) {
            Button("Ok") { showError = false }
        } message: {
            Text(errorMessage ?? "error")
        }
        .animation(.spring(), value: mode)
        
    }
    
    func loginOrRegisterOrNextField() {
        
        nextField()
        
        if mode == .register {
            guard name != "" else { return }
        }
        
        guard email != "" && password != "" else { return }
        
        logic.isLoading = true
        
        if mode == .register {
            database.register(email: email, password: password) { error in
                checkForErrors(error: error)
            }
        } else {
            database.signIn(email: email, password: password) { error in
                checkForErrors(error: error)
            }
        }
        
        func checkForErrors(error: Error?) {
            if error == nil {
                loginSuccess()
            } else {
                loginError(error: error!)
            }
        }
        
        func loginSuccess() {
            if database.userIsLoggedIn {
                database.userIsLoggedIn = true
                logic.selectedScreen = .topResults
                logic.isLoading = false
            }
        }
        
        func loginError(error: Error) {
            errorMessage = error.localizedDescription
            showError = true
            logic.isLoading = false
        }
        
    }
    
    func nextField() {
        if mode == .register && name == "" {
            focus = .name
            return
        }
        
        if email == "" {
            focus = .email
            return
        } else if password == "" {
            focus = .password
            return
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
