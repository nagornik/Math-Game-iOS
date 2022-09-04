//
//  TextButton.swift
//  Math Game
//
//  Created by Anton Nagornyi on 27.08.2022.
//

import SwiftUI

struct TextButton: View {
    
    @EnvironmentObject var logic: ViewModel
    
    var text: String
    var size: CGFloat = 40
    
    var body: some View {
        
        Text(text)
            .padding()
            .padding(.horizontal)
            .font(.system(size: size, weight: .bold))
            .background(Color(logic.difficulty.rawValue == text ? "selectedButton" : "buttonBack"))
            .foregroundColor(Color("buttonForeground"))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
        
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "Start")
            .environmentObject(ViewModel())
    }
}
