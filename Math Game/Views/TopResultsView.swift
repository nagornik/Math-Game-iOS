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
    
    var body: some View {
        Text("Top results!")
            .onTapGesture {
                try? Auth.auth().signOut()
                logic.selectedScreen = .login
            }
    }
}

struct TopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TopResultsView()
            .environmentObject(ViewModel())
    }
}
