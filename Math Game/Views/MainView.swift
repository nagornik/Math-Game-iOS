//
//  MainView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 29.08.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
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
                    case .topResults:
                        TopResultsView()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    case .login:
                        LoginView()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
            }
            
            if logic.isLoading {
                ZStack {
                    Color.black
                        .opacity(0.3)
                    ProgressView()
                }
                .transition(.opacity)
                .ignoresSafeArea()
            }

        }
        .animation(.spring().speed(0.5), value: logic.selectedScreen)
        .animation(.spring().speed(0.5), value: logic.isAnswered)
        .animation(.spring().speed(0.5), value: logic.isLoading)
        .onAppear {
            database.downloadAndUpdateScore(allTopScores: logic.allTopScores) { data in
                if data != nil {
                    logic.allTopScores = data!
                } else {
                    logic.allTopScores = logic.getAllTopScoresFromLocal() ?? [String : Int]()
                }
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
            .preferredColorScheme(.dark)
    }
}
