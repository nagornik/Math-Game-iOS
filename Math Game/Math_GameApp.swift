//
//  Math_GameApp.swift
//  Math Game
//
//  Created by Anton Nagornyi on 20.04.2022.
//

import SwiftUI
import FirebaseCore

@main
struct Math_GameApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ViewModel())
        }
    }
}
