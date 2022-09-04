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
    
    var usersSorted: [OtherUser] {
        return users.sorted(by: {($0.topScores[logic.difficultyForTopScore.rawValue] ?? 0) ?? 0 > ($1.topScores[logic.difficultyForTopScore.rawValue] ?? 0) ?? 0})
    }
    
    @Binding var drag: CGFloat
    
    var body: some View {
        
        VStack {
            
            VStack {
                
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
                
                VStack {
                    
                    YourTop(profilePic: database.profilePic, username: database.name, topScore: logic.allTopScores[logic.difficultyForTopScore.rawValue] ?? 0, number: myPosition())
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(usersSorted, id:\.id) { user in
                            VStack {
                                if user.topScores[logic.difficultyForTopScore.rawValue]! ?? 0 > 0 {

                                    UserRow(user: user, number: getUserNumber(user: user))

                                }
                            }
                        }
                        
                    }
                    .safeAreaInset(edge: .bottom) {
                        Color.clear
                            .frame(height: 60)
                    }
                    
                }
                .offset(x: drag)
                
            }
            .onAppear {
                database.getAllUsers { users in
                    self.users = users
                }
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.easeInOut, value: logic.difficultyForTopScore.rawValue)
        
        
        
    }
    
    func getUserNumber(user: OtherUser) -> Int {
        let number = usersSorted.firstIndex(where: {$0.id == user.id})
        if number == nil {
            return usersSorted.count
        } else {
            return number! + 1
        }
    }
    
    func myPosition() -> Int {
        let index = usersSorted.firstIndex(where: {$0.topScores[logic.difficultyForTopScore.rawValue] == logic.allTopScores[logic.difficultyForTopScore.rawValue]})
        if index != nil {
            return index! + 1
        } else {
            return usersSorted.count + 1
        }
    }
    
}

struct TopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TopResultsView(drag: .constant(0))
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
