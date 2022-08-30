//
//  TopMenuButton.swift
//  Math Game
//
//  Created by Anton Nagornyi on 30.08.2022.
//

import SwiftUI

struct TopMenuButton: View {
    
//    @EnvironmentObject var logic: ViewModel
    
    var systemName: String
    var action: () -> Void
    
    var body: some View {
        
        
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(Color("text"))
                .padding()
        }
        
        
    }
}

//struct TopMenuButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TopMenuButton()
//            .environmentObject(ViewModel())
//    }
//}
