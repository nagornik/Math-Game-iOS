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
    
    // MARK: - Dummy data uploading
    
//    var men = ["James","John","Robert","Michael","William","David","Richard","Charles","Joseph"]
//    var women = ["Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan"]
//
//    func uploadDummyData() {
//
//        var num = 10
//
//        for name in men {
//            let userId = UUID().uuidString
//            let ref = db.collection("users").document(userId)
//            ref.setData(["name" : name], merge: true)
//            let url = "https://randomuser.me/api/portraits/med/men/\(num).jpg"
//            num += 1
//            ref.setData(["photo" : url], merge: true)
//            for diff in Difficulties.allCases {
//                ref.setData([diff.rawValue : Int.random(in: 0...99)], merge: true)
//            }
//        }
//
//        num = 10
//
//        for name in women {
//            let userId = UUID().uuidString
//            let ref = db.collection("users").document(userId)
//            ref.setData(["name" : name], merge: true)
//            let url = "https://randomuser.me/api/portraits/med/women/\(num).jpg"
//            num += 1
//            ref.setData(["photo" : url], merge: true)
//            for diff in Difficulties.allCases {
//                ref.setData([diff.rawValue : Int.random(in: 0...99)], merge: true)
//            }
//        }
//
//    }
    
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
    @Published var isUploadingPic = false
    
    init() {
        if name == "" {
            name = "Player\(Int.random(in: 1...1000))"
        }
        userIsLoggedIn = isLoggedIn()
        if isLoggedIn() {
            downloadProfilePicAndName()
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
                self.downloadProfilePicAndName()
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
    
    func downloadAndUpdateScore(allTopScores: [String : Int], completion: @escaping ([String : Int]?) -> Void) {
        guard isLoggedIn() else { return }
        var updatedTopScore = [String : Int]()
        let userId = Auth.auth().currentUser!.uid
        let ref = db.collection("users").document(userId)
        ref.getDocument { snap, error in
            guard error == nil && snap != nil else { return }
            for diff in Difficulties.allCases {
                let databaseScore = snap![diff.rawValue] as? Int ?? 0
                if databaseScore > allTopScores[diff.rawValue] ?? 0 {
                    updatedTopScore[diff.rawValue] = databaseScore
                } else {
                    updatedTopScore[diff.rawValue] = allTopScores[diff.rawValue] ?? 0
                    let localScore = allTopScores[diff.rawValue] ?? 0
                    ref.setData([diff.rawValue : localScore], merge: true)
                }
            }
            completion(updatedTopScore)
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        userIsLoggedIn = false
    }
    
    func uploadImage(image: UIImage) {
        
        guard isLoggedIn() else { return }
        isUploadingPic = true
        
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
                self.isUploadingPic = false
                return
            }
            
            fileRef.downloadURL { url, error in
                if error != nil {
                    self.isUploadingPic = false
                    return
                }
                
                guard url != nil else {
                    self.isUploadingPic = false
                    return
                }
                
                doc.setData(["photo" : url!.absoluteString], merge: true) { error in
                    self.isUploadingPic = false
                    if error != nil {
                        return
                    }
                }
                
            }
            
        }
        
    }
    
    func downloadProfilePicAndName() {
        guard isLoggedIn() else { return }
        let userId = Auth.auth().currentUser!.uid
        let doc = db.collection("users").document(userId)
        doc.getDocument { snap, error in
            guard error == nil && snap != nil else { return }
            
            if snap!["name"] as? String != nil {
                self.name = snap!["name"] as! String
            }
            
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
                    topScores: [
                        "Very easy" : doc["Very easy"] as? Int,
                        "Easy" : doc["Easy"] as? Int,
                        "Medium" : doc["Medium"] as? Int,
                        "Hard" : doc["Hard"] as? Int,
                        "Ultra hard" : doc["Ultra hard"] as? Int
                    ],
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
