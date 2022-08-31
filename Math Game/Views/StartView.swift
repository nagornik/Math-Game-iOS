//
//  StartView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 31.05.2022.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var logic: ViewModel
//    @AppStorage("highScore") var highScore = 0
    
    @State var progressValue: Float = 0.0
    
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
    
            VStack {
                
                Text("Math Game")
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .font(.system(size: 55, weight: .bold))
                    .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    .padding(.bottom, 50.0)
                
                VStack {

                    timerRing

                    Text("\(Int.random(in: 0...50)) + \(Int.random(in: 0...50)) = ?")
                        .font(.system(size: 45, weight: .bold))
                        .bold()
                        .foregroundColor(Color("text"))

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {

                        ForEach(0..<4) { num in
                            AnswerButton(number: Int.random(in: 0...100))
                        }
                    }

                }
                .frame(width: screen.width/1.5, height: 320)
                .scaleEffect(0.5)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .clipped()
                
                Spacer()
                
                Button {
                    logic.selectedScreen = .game
                } label: {
                    TextButton(text: "Start")
                }
                
                Text("Top Score: \(logic.currecntTopScore)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color("text"))
                
            }
            
            
        }
    }
    
    var timerRing: some View {
        
        TimerView(timeRemaning: $logic.timeRemaning, progress: $logic.progress)
            .frame(width: screen.width / 2, height: screen.width / 2)
            .onAppear(perform: {
                logic.resetTimer()
            })
            .onReceive(logic.everySecTimer) { _ in
                
                if logic.selectedScreen == .start {
                    logic.timeRemaning -= 1
                    logic.progress = Float(1 - (logic.timeRemaning / 5.0))
                    
                    if logic.timeRemaning < 0 {
                        logic.timeRemaning = 5
                        logic.progress = 0
                    }
                }
                
            }
            .padding()
            .disabled(true)
        
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ViewModel())
    }
}
