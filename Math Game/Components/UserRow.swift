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
        
        
        VStack(spacing: 0.0) {
            HStack(spacing: 16.0) {
                HStack(spacing: 16.0) {
                    AsyncImageView(imageUrlString: user.photo ?? "")
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(user.name)
                        .font(.system(.title2, design: .rounded))
                }
                .transition(.move(edge: .leading))
                
                Spacer()
                
                Text("\(user.topScores[logic.difficultyForTopScore.rawValue]! ?? 0)")
                    .fontWeight(.black)
                    .font(.system(.title, design: .rounded))
                    .transition(.move(edge: .trailing))
                    .padding(.trailing)
            }
            .foregroundColor(Color("text"))
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            
//            Divider()
//                .transition(.move(edge: .bottom))
            
        }
        .padding(.horizontal)
        
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: OtherUser(id: UUID().uuidString, name: "Anton", topScores: [Difficulties.medium.rawValue : 5], photo: "https://randomuser.me/api/portraits/men/15.jpg"))
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
