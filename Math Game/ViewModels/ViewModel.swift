//
//  ViewModel.swift
//  Math Game
//
//  Created by Anton Nagornyi on 27.08.2022.
//

import Foundation
import SwiftUI

enum ShowedScreen {
    case start
    case game
    case settings
}

enum Difficulties: String, CaseIterable {
    case veryEasy = "Very easy"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case ultraHard = "Ultra hard"
}

class ViewModel: ObservableObject {
    
    @Published var selectedScreen: ShowedScreen = .start
    
    @Published var timeRemaning: Float = 5.0
    @Published var progress: Float = 0
    
    @Published var correctAnswer = 0
    @Published var choiceArray : [Int] = []
    @Published var firstNumber = 0
    @Published var secondNumber = 0
    @Published var difficulty: Difficulties = .medium {
        didSet {
            score = 0
        }
        willSet {
            allTopScores[difficulty.rawValue] = score
        }
    }
    
    var difficultyNumber: Int {
        switch difficulty {
            case .veryEasy:
                return 20
            case .easy:
                return 60
            case .medium:
                return 100
            case .hard:
                return 400
            case .ultraHard:
                return 1000
        }
    }
    
    @Published var score = 0
    
    @AppStorage("highScore") var topScore = 0
//    @AppStorage("highScores") var topScores = [String : Int]()
    var allTopScores: [String : Int] = [:]
    
    @Published var isAnswered = false
    @Published var isSelected = Int()
    
    
    var everySecTimer = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common).autoconnect()
   
    func generateQuestion() {
        firstNumber = Int.random(in: 0...(difficultyNumber/2))
        secondNumber = Int.random(in: 0...(difficultyNumber/2))
        correctAnswer = firstNumber + secondNumber
    }
    
    func generateAnswers() {

        func addFourItemsToArray() {
            choiceArray.removeAll()
            for _ in 0..<3 {
                choiceArray.append(Int.random(in: 0...difficultyNumber))
            }
            choiceArray.append(correctAnswer)
            choiceArray.shuffle()
        }
        
        func containsDuplicates() -> Bool {
            for i in 0..<choiceArray.count {
                if choiceArray.dropFirst(i + 1).contains(choiceArray[i]) {
                    return true
                }
            }
            return false
        }
        
        repeat {
            addFourItemsToArray()
        } while containsDuplicates()
        
    }
    
    func resetTimer() {
        timeRemaning = 5
        progress = 0
        startTimer()
    }
    
    func checkIfAnswerIsCorrect(answer: Int) {
    
        if answer == correctAnswer {
            score += 1
        } else if score > 0 {
            score -= 1
        }
        
        if score > topScore {
            topScore = score
        }
 
    }
    
    func stopTimer() {
        everySecTimer.upstream.connect().cancel()
    }
    
    func startTimer() {
        everySecTimer = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common).autoconnect()
    }
    
    func nextQuestion() {
        generateQuestion()
        generateAnswers()
        timeRemaning = 5
        progress = 0
        isSelected = Int()
        isAnswered = false
        startTimer()
    }
    
    func answer(number: Int) {
        checkIfAnswerIsCorrect(answer: number)
        stopTimer()
        isAnswered = true
        isSelected = number
    }
    
}