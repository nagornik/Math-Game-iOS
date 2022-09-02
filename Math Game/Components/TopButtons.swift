//
//  TopButtons.swift
//  Math Game
//
//  Created by Anton Nagornyi on 30.08.2022.
//

import SwiftUI

struct TopButtons: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    var body: some View {
        
        HStack(spacing: 16) {
        
            if logic.selectedScreen == .settings {
                
                Text("Settings")
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(Color("text"))
                    .transition(.move(edge: .leading).combined(with: .opacity))
                
            } else if logic.selectedScreen == .game && logic.isAnswered {
                
                TopMenuButton(systemName: "house.fill", action: {
                    logic.selectedScreen = .start
                })
                .transition(.move(edge: .leading).combined(with: .opacity))
                
            }
                
            Spacer()
            
            if logic.selectedScreen != .game || logic.isAnswered {
                
                TopMenuButton(systemName: "chart.bar.xaxis", action: {
                    logic.selectedScreen = database.isLoggedIn() ? .topResults : .login
                })
                .transition(.move(edge: .trailing).combined(with: .opacity))
                
                if logic.selectedScreen == .settings {
                    TopMenuButton(systemName: "xmark") {
                        logic.selectedScreen = .start
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    TopMenuButton(systemName: "gearshape.fill") {
                        logic.selectedScreen = .settings
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
                
            }
                
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        
    }
}

struct TopButtons_Previews: PreviewProvider {
    static var previews: some View {
        TopButtons()
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
