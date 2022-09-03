//
//  UserRow.swift
//  Math Game
//
//  Created by Anton Nagornyi on 02.09.2022.
//

import SwiftUI

struct UserRow: View {
    
    @EnvironmentObject var logic: ViewModel
    
    var user: OtherUser
    
    var body: some View {
        
        
        VStack {
            HStack(spacing: 16.0) {
                AsyncImageView(imageUrlString: user.photo ?? "")
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                Text(user.name)
                    .font(.system(.title2, design: .rounded))
                
                Spacer()
                
                Text("\(user.topScores[logic.difficultyForTopScore.rawValue]! ?? 0)")
                    .fontWeight(.black)
                    .font(.system(.title, design: .rounded))
            }
            .foregroundColor(Color("text"))
            .padding()
            
            Divider()
            
        }
        .padding(.horizontal)
        
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: OtherUser(id: UUID().uuidString, name: "Anton", veryEasy: 5, easy: 2, medium: nil, hard: nil, ultraHard: nil, topScores: [Difficulties.medium.rawValue : 5], photo: "https://randomuser.me/api/portraits/men/15.jpg"))
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
