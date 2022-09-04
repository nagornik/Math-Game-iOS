//
//  YourTop.swift
//  Math Game
//
//  Created by Anton Nagornyi on 03.09.2022.
//

import SwiftUI

struct YourTop: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    var profilePic: UIImage?
    var username: String
    var topScore: Int
    var number: Int
    
    var body: some View {
        
        VStack {
            
            ZStack {
                if let profilePic = profilePic {
                    Image(uiImage: profilePic)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("text"))
                        .frame(width: 30, height: 30)
                        
                }
            }
            .frame(width: 70, height: 70)
            .background(.white)
            .clipShape(Circle())
            
            
            HStack {
                Text("# \(number)")
                    .fontWeight(.bold)
                    .font(.system(.body, design: .rounded))
                Text(username)
                    .bold()
                    .font(.system(.title2, design: .rounded))
            }
            
            HStack {
                Text("Top score: ")
                    .fontWeight(.light)
                Text("\(topScore)")
                    .fontWeight(.black)
            }
            .font(.system(.title2, design: .rounded))
            
        }
        .foregroundColor(Color("text"))
        
    }
}

struct YourTop_Previews: PreviewProvider {
    static var previews: some View {
        YourTop(profilePic: DatabaseService().profilePic, username: DatabaseService().name, topScore: ViewModel().allTopScores[ViewModel().difficultyForTopScore.rawValue] ?? 0, number: 12)
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
