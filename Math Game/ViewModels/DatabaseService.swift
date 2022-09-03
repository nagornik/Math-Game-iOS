//
//  DatabaseService.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.08.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import UIKit

class DatabaseService: ObservableObject {
    
    var imageCache = [String : Image]()
    
    func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
    
    let db = Firestore.firestore()
    @Published var userIsLoggedIn = false
    @AppStorage("name") var name = ""
    @Published var profilePic: UIImage? {
        willSet {
            if newValue != nil {
                uploadImage(image: newValue!)
            }
        }
    }
    
    init() {
        if name == "" {
            name = "Player\(Int.random(in: 1...1000))"
        }
        userIsLoggedIn = isLoggedIn()
        if isLoggedIn() {
            downloadImage()
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
                completion(nil)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error)
            } else if result != nil {
                self.userIsLoggedIn = true
                self.downloadImage()
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
    
    func uploadImage(image: UIImage) {
        
        guard isLoggedIn() else { return }
        
        let userId = Auth.auth().currentUser!.uid
        let doc = db.collection("users").document(userId)
        
        let storageRef = Storage.storage().reference()
        let resizedImage = image.resizeWithWidth(width: 300)
        guard resizedImage != nil else { return }
        let imageData = resizedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else { return }
        
        let path = "images/\(userId).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData!, metadata: nil) { meta, error in
            
            if error != nil {
                return
            }
            
            fileRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                
                guard url != nil else { return }
                
                doc.setData(["photo" : url!.absoluteString], merge: true) { error in
                    if error != nil {
                        return
                    }
                }
                
            }
            
        }
        
    }
    
//    func uploadImage(image: UIImage, completion: @escaping (Error?) -> Void) {
//
//        guard isLoggedIn() else { return }
//
//        let userId = Auth.auth().currentUser!.uid
//        let doc = db.collection("users").document(userId)
//
//        let storageRef = Storage.storage().reference()
//        let resizedImage = image.resizeWithWidth(width: 300)
//        guard resizedImage != nil else { return }
//        let imageData = resizedImage!.jpegData(compressionQuality: 0.8)
//
//        guard imageData != nil else { return }
//
//        let path = "images/\(userId).jpg"
//        let fileRef = storageRef.child(path)
//
//        fileRef.putData(imageData!, metadata: nil) { meta, error in
//
//            if error != nil {
//                completion(error)
//            }
//
//            fileRef.downloadURL { url, error in
//                if error != nil {
//                    completion(error)
//                }
//
//                guard url != nil else { return }
//
//                doc.setData(["photo" : url!.absoluteString], merge: true) { error in
//                    if error != nil {
//                        completion(error)
//                    }
//                }
//
//            }
//
//        }
//
//    }
    
    func downloadImage() {
        guard isLoggedIn() else { return }
        let userId = Auth.auth().currentUser!.uid
        let doc = db.collection("users").document(userId)
        doc.getDocument { snap, error in
            guard error == nil && snap != nil else { return }
            
            guard (snap!["photo"] as? String) != nil else { return }
            
            guard let url = URL(string: snap!["photo"] as! String) else { return }
            
            URLSession.shared.dataTask(with: url) { data, responce, error in
                guard error == nil && data != nil else { return }
                DispatchQueue.main.async {
                    self.profilePic = UIImage(data: data!)
                }
            }
            .resume()
        }
    }
    
    func getAllUsers(completion: @escaping ([OtherUser]) -> Void) {
        guard isLoggedIn() else { return }
        var users = [OtherUser]()
        let collection = db.collection("users")
        collection.getDocuments(completion: { snap, error in
            guard error == nil && snap != nil else { return }
            for doc in snap!.documents {
                let user = OtherUser(
                    id: doc.documentID,
                    name: doc["name"] as? String ?? "Player \(Int.random(in: 100...10000))",
                    veryEasy: doc["Very easy"] as? Int,
                    easy: doc["Easy"] as? Int,
                    medium: doc["Medium"] as? Int,
                    hard: doc["Hard"] as? Int,
                    ultraHard: doc["Ultra hard"] as? Int,
                    topScores: ["Very easy" : doc["Very Easy"] as? Int, "Easy" : doc["Easy"] as? Int, "Medium" : doc["Medium"] as? Int, "Hard" : doc["Hard"] as? Int, "Ultra hard" : doc["Ultra hard"] as? Int],
                    photo: doc["photo"] as? String
                )
                users.append(user)
            }
            completion(users)
        })
        
    }
    
    
    
    
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
