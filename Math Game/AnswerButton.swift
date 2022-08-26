//
//  AnswerButton.swift
//  Math Game
//
//  Created by Anton Nagornyi on 20.04.2022.
//

import SwiftUI

struct AnswerButton: View {
    
    var number:Int
    
    var body: some View {
        
        Text("\(number)")
            .frame(width: 100, height: 100)
            .font(.system(size: 40, weight: .bold))
            .background(Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)))
            .foregroundColor(Color(UIColor(hue:0.09, saturation:0.06, brightness:1.00, alpha:1.00)))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding()
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
    }
    
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(number: 100)
    }
}
