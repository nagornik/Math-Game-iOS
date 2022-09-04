//
//  GameView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 27.08.2022.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var logic: ViewModel
    @EnvironmentObject var database: DatabaseService
    
    var title: String {
        if logic.timeRemaning == 5 {
            return "Find the answer"
        } else if logic.timeRemaning == 4 {
            return "Hurry up"
        } else if logic.timeRemaning == 3 {
            return "Hurry uuup!!!"
        } else if logic.timeRemaning == 2 {
            return "Faster!"
        } else if logic.timeRemaning == 1 {
            return "You won't make it..."
        } else {
            return "The END"
        }
    }
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0.0) {
                
                if !logic.isAnswered {
                    
                    titleAndTimer
                        .transition(.move(edge: .top).combined(with: .opacity))
                    
                } else {
                    Spacer()
                    scores
                }
                
                questionAndAnswers
                    .disabled(logic.isAnswered)

                scoresOrNextButton
                
                Spacer()
            }
            
        }
        .onAppear {
            logic.generateQuestion()
            logic.generateAnswers()
            logic.resetTimer()
        }
           
    }
    
    var titleAndTimer: some View {
        
        VStack {
        
            Text(title)
            .font(.system(size: 30, weight: .bold))
            .bold()
            .foregroundColor(Color("text"))
            .padding(20.0)
        
        TimerView(timeRemaning: $logic.timeRemaning, progress: $logic.progress)
            .frame(width: screen.width / 2, height: screen.width / 2)
            .onReceive(logic.everySecTimer) { _ in
                
                if !logic.isAnswered && logic.selectedScreen == .game {
                    logic.timeRemaning -= 1
                    logic.progress = Float(1 - (logic.timeRemaning / 5.0))
                    
                    if logic.timeRemaning < 0 {
                        logic.isAnswered = true
                        logic.checkIfAnswerIsCorrect(answer: Int())
                    }
                }
                
            }
            
        }
    }
    
    var scores: some View {
        VStack {
            Text("Top Score: \(logic.currecntTopScore)")
                .font(.subheadline)
                .bold()
                .foregroundColor(Color("text"))
            
            Text("Score: \(logic.score)")
                .font(.title)
                .bold()
                .foregroundColor(Color("text"))
        }
    }
    
    var questionAndAnswers: some View {
        VStack {
            Text("\(logic.firstNumber) + \(logic.secondNumber) = ?")
                .font(.system(size: 45, weight: .bold))
                .bold()
                .foregroundColor(Color("text"))
                .padding(.top, 24)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                
                ForEach(logic.choiceArray, id:\.self) { num in
                    
                    Button {
                        logic.answer(number: num)
                    } label: {
                        AnswerButton(number: num)
                    }
//                    .transition(.scale.combined(with: .opacity))
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .frame(width: screen.width/1.5)
//            .transition(.move(edge: .leading))
        }
        .onChange(of: logic.allTopScores) { newValue in
            database.uploadUserData(allTopScores: newValue)
        }
        
    }
    
    var scoresOrNextButton: some View {
        
        VStack {
            if !logic.isAnswered {
                scores
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Button {
                    logic.nextQuestion()
                } label: {
                    TextButton(text: "Next")
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.top)
        
    }
    
    
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(ViewModel())
            .environmentObject(DatabaseService())
    }
}
