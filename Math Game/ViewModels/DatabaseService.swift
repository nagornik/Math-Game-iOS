//
//  DatabaseService.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.08.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class DatabaseService: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var userIsLoggedIn = false
    @AppStorage("name") var name = ""
    
    init() {
        userIsLoggedIn = isLoggedIn()
        if name == "" {
            name = "Player\(Int.random(in: 1...1000))"
        }
    }
    
    func isLoggedIn() -> Bool {
        
        if Auth.auth().currentUser == nil {
            userIsLoggedIn = false
            return false
        } else {
            userIsLoggedIn = true
            return true
        }
        
    }
    
    func register(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error)
            } else if result != nil {
                self.userIsLoggedIn = true
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error)
            } else if result != nil {
                self.userIsLoggedIn = true
                completion(nil)
            }
        }
    }

    func uploadUserData(allTopScores: [String : Int]) {
        guard isLoggedIn() else { return }
        let userId = Auth.auth().currentUser!.uid
        let ref = db.collection("users").document(userId)
        ref.setData(["name" : name.trimmingCharacters(in: .whitespacesAndNewlines)], merge: true)
        for (key, value) in allTopScores {
            ref.setData([key : value], merge: true)
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        userIsLoggedIn = false
    }
    
    
    
    
    
    
    
}
