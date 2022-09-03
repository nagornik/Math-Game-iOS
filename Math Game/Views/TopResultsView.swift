//
//  TopResultsView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.08.2022.
//

import SwiftUI
import FirebaseAuth

struct TopResultsView: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    @State var users = [OtherUser]()
    
    var body: some View {
        
        VStack {
            
            LazyVStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Difficulties.allCases, id:\.self) { diff in
                            DifficultyButtonTopScore(text: diff.rawValue) {
                                logic.difficultyForTopScore = diff
                            }
                        }
                    }
                    .padding()
                }
                
                YourTop(profilePic: database.profilePic, username: database.name, topScore: logic.allTopScores[logic.difficultyForTopScore.rawValue] ?? 0)
                
                if users.count == 0 {
                    Text("no users")
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(users.sorted(by: {
                        $0.topScores[logic.difficultyForTopScore.rawValue]! ?? 0 > $1.topScores[logic.difficultyForTopScore.rawValue]! ?? 0
                    })) { user in
                        if user.topScores[logic.difficultyForTopScore.rawValue]! ?? 0 > 0 {
                            UserRow(user: user)
                        }
                    }
                    
                }
                
            }
            .onAppear {
                database.getAllUsers { users in
                    self.users = users
                }
            }
            
            Spacer()
            
        }
        
        
    }
}

struct TopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TopResultsView()
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
