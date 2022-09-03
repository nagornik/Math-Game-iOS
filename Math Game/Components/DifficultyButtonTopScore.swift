//
//  DifficultyButtonTopScore.swift
//  Math Game
//
//  Created by Anton Nagornyi on 02.09.2022.
//

import SwiftUI

struct DifficultyButtonTopScore: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    var text: String
    var action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Text(text)
                .bold()
                .font(.caption)
                .padding()
                .background(Color(logic.difficultyForTopScore.rawValue == text ? "selectedButton" : "buttonBack"))
                .foregroundColor(Color("buttonForeground"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
        }

        
    }
}

struct DifficultyButtonTopScore_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyButtonTopScore(text: Difficulties.veryEasy.rawValue, action: {})
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
