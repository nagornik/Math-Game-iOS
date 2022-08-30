//
//  AnswerButton.swift
//  Math Game
//
//  Created by Anton Nagornyi on 20.04.2022.
//

import SwiftUI

struct AnswerButton: View {
    
    @EnvironmentObject var logic: ViewModel
    
    var number:Int
    
    var backgroundColor: Color {
        if logic.isAnswered {
            if number == logic.isSelected && number != logic.correctAnswer || logic.isSelected == Int() && number == logic.correctAnswer {
                return .red
            } else if number == logic.isSelected && number == logic.correctAnswer || number == logic.correctAnswer {
                return .green
            } else {
                return .gray
            }
        } else {
            return Color("buttonBack")
        }
    }
    
    var body: some View {
        
        Text("\(number)")
            .frame(width: 100, height: 100)
            .font(.system(size: 40, weight: .bold))
            .background(backgroundColor)
            .foregroundColor(Color("buttonForeground"))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding()
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
        
    }
    
}
