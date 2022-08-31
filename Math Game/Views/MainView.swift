//
//  MainView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 29.08.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var logic: ViewModel
    
    var body: some View {
        
        ZStack {
            
            Color("back")
                    .ignoresSafeArea()
            Color("accent")
                    .rotationEffect(Angle(degrees: 45))
                    .blur(radius: 20)
                    .ignoresSafeArea()
            
            VStack {
                TopButtons()
                
                switch logic.selectedScreen {
                    case .start:
                        StartView()
                            .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity)))
                    case .game:
                        GameView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                    case .settings:
                        SettingsView()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
            }
           
        }
        
        .animation(.spring().speed(0.5), value: logic.selectedScreen)
        .animation(.spring().speed(0.5), value: logic.isAnswered)
        .onAppear {
            logic.generateQuestion()
            logic.generateAnswers()
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
