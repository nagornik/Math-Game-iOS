//
//  ContentView.swift
//  Math Game
//
//  Created by Anton Nagornyi on 20.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var correctAnswer = 0
    @State private var choiceArray : [Int] = [0,1,2,3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var difficulty = 100
    @State private var score = 0
    @State private var topScore = 0
    @State var tap = false
    @State var toResetShow = false
    @State var bgWidth = 200.0
    let everySec = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    let veryFast = Timer.publish(every: 0.01, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State var goUp = true
    @State var timeRectangle = 400.0
    @State var showRectangle = true
    @State var justTimer = 5
    var redColor = Color(UIColor(hue:0.98, saturation:0.84, brightness:0.97, alpha:1.00))
    var greenColor = Color(UIColor(hue:0.39, saturation:0.76, brightness:0.80, alpha:1.00))
    
    @Namespace var namespace
    @State var show = true
    
    var body: some View {
        if show == true {
            ZStack {
                
                Color(UIColor(hue:0.12, saturation:0.51, brightness:0.95, alpha:1.00)).ignoresSafeArea()
                Color(UIColor(hue:0.48, saturation:0.27, brightness:0.85, alpha:1.00)).matchedGeometryEffect(id: "bg", in: namespace).rotationEffect(Angle(degrees: 45)).ignoresSafeArea().blur(radius: 5)
                    .frame(width: goUp ? 200 : 700)
//                    .animation(.easeInOut(duration: 1), value: goUp)
//                    .onReceive(everySec) { _ in
//                        goUp.toggle()
//                        if justTimer > 0 {
//                            justTimer -= 1
//                        }
//                    }
                    .onChange(of: correctAnswer, perform: { x in
                        while justTimer > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                justTimer -= 1
                            }
                        }
                        
                    })
                
                
                VStack {
                    Spacer()
                    Text("\(justTimer) sec")
                        .font(.system(size: 45, weight: .bold))
                        .bold()
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                        .padding(.bottom, 20.0)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: showRectangle ? 400 : 1, height: 20, alignment: .leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 45)
                        .animation(.easeInOut(duration: 5), value: showRectangle)
                        .foregroundColor(showRectangle ? greenColor : redColor)
                        .padding(.bottom, 20.0)
//                    Spacer()
//                    Text("Find the answer")
//                        .bold()
//                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    Text("\(firstNumber) + \(secondNumber) = ?")
                        .font(.system(size: 45, weight: .bold))
                        .bold()
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    HStack {
                        ForEach(0..<2) {
                            num in
                            Button {
                                answerIsCorrect(answer: choiceArray[num])
                                generateQuestion()
                                generateAnswers()
                            } label: {
                                AnswerButton(number: choiceArray[num])
                                
                            }
                        }
                    }
                    HStack {
                        ForEach(2..<4) { index in
                            Button {
                                answerIsCorrect(answer: choiceArray[index])
                                generateQuestion()
                                generateAnswers()
                            } label: {
                                AnswerButton(number: choiceArray[index])
                            }
                        }
                    }
                    
                    Text("Top Score: \(topScore)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    
                    Text("Score: \(score)")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
                    
                    Spacer()
                
                }.onAppear(perform: generateQuestion).onAppear(perform: generateAnswers)
                
                VStack{
//                    Text("Math Game")
//                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .font(.system(size: 55, weight: .bold))
//                        .foregroundColor(Color(UIColor(hue:0.70, saturation:0.46, brightness:0.35, alpha:1.00)))
//                        .padding(.top, 50.0)
                    Spacer()
                    if score != 0 {
                        Button {
                            toResetShow = true
                        } label: {
                                Text("Restart")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding()
                                    .background(Color(UIColor(hue:0.07, saturation:0.83, brightness:0.99, alpha:1.00)))
                                    .foregroundColor(Color(UIColor(hue:0.09, saturation:0.06, brightness:1.00, alpha:1.00)))
                                    .cornerRadius(30)
                                    .scaleEffect(0.8)
                        }.alert(isPresented: $toResetShow) {
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("This action will reset the game."),
                                primaryButton: .default(
                                    Text("Yes, reset"),
                                    action:
                                        resetAll
                                ),
                                secondaryButton: .destructive(
                                    Text("No, go back"),
                                    action: hideAlert
                                )
                            )
                        }
                    }
                }
                
                if justTimer == 0 {
                    Color(UIColor(hue:0.0, saturation:0.0, brightness:0.0, alpha:0.8)).ignoresSafeArea()
                    VStack {
                        Text("Time's up!")
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                            .font(.system(size: 55, weight: .bold))
                            .foregroundColor(Color(UIColor(hue:0.09, saturation:0.06, brightness:1.00, alpha:1.00)))
                        .padding(.bottom, 50.0)
                        Text("You lose one score")
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(UIColor(hue:0.09, saturation:0.06, brightness:1.00, alpha:1.00)))
                            .padding(.bottom, 50.0)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            showRectangle = true
                            answerIsCorrect(answer: 0)
                            generateQuestion()
                            generateAnswers()
                        }
                    }
                }
                
                
            }
        } else {
            
            
        }
        
        
    }
    
    
    func answerIsCorrect(answer: Int) {
    
        if answer == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
        
        if score > topScore {
            topScore = score
        }
 
    }
    
    func generateQuestion() {
        firstNumber = Int.random(in: 0...(difficulty/2))
        secondNumber = Int.random(in: 0...(difficulty/2))
        correctAnswer = firstNumber + secondNumber
    }
    
    func generateAnswers() {
        
        timeRectangle = 400.0
        justTimer = 5
        
        showRectangle = false
        
        var a = 0
        var b = 0
        
        repeat {
            choiceArray.removeAll()
            for _ in 0..<3 {
                choiceArray.append(Int.random(in: 0...difficulty))
            }
            choiceArray.append(correctAnswer)
            choiceArray.shuffle()
            let log = choiceArray
            for num in 0...3 {
                a = choiceArray.firstIndex(of: log[num])!
                b = choiceArray.lastIndex(of: log[num])!
            }
        } while (a != b)
    
    }
    
    func resetAll() {
        toResetShow = false
        generateQuestion()
        generateAnswers()
        score = 0
        topScore = 0
    }
    
    func hideAlert() {
        toResetShow = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
