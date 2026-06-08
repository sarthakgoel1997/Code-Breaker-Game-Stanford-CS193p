//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 1/1/26.
//

import SwiftUI

typealias Peg = String

let supportedColors: [String: Color] = [
    "red": .red,
    "blue": .blue,
    "green": .green,
    "yellow": .yellow,
    "black": .black,
    "orange": .orange,
    "pink": .pink,
    "purple": .purple,
    "brown": .brown,
    "cyan": .cyan,
    "indigo": .indigo,
]

extension String {
    var pegColor: Color? {
        supportedColors[self]
    }
}

struct CodeBreaker {
    var name: String
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    var pegChoices: [Peg]
    var currentGame: GameType
    var startTime: Date = Date.now
    var endTime: Date?
    
    static let availableColors: [String] = Array(supportedColors.keys)
    static let availableEmojis: [String] = ["🙂", "📁", "🚀", "🔥", "😂", "🐕", "🚗", "⚽️"]
    
    enum GameType {
        case color
        case emoji
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
        self.name = name
        if let _ = pegChoices[0].pegColor {
            currentGame = .color
        } else {
            currentGame = .emoji
        }
        
        self.pegChoices = pegChoices
        let pegsCount = Int.random(in: 3...6)
        
        masterCode = Code(kind: .master(isHidden: true), pegsCount: pegsCount)
        masterCode.randomize(from: pegChoices, pegsCount: pegsCount)
        
        guess = Code(kind: .guess, pegsCount: pegsCount)
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        if emptyAttempt() || attemptAlreadyMade() {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func restart() {
        randomizePegChoices()
        
        let newPegsCount = Int.random(in: 3...6)
        
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices, pegsCount: newPegsCount)
        
        guess.resetPegs(pegsCount: newPegsCount)
        attempts.removeAll()
        
        startTime = .now
        endTime = nil
    }
    
    mutating func randomizePegChoices() {
        let count = Int.random(in: 3...6)
        let colorGame = Bool.random()
        
        if colorGame {
            currentGame = .color
            pegChoices = Array(CodeBreaker.availableColors.shuffled().prefix(count))
        } else {
            currentGame = .emoji
            pegChoices = Array(CodeBreaker.availableEmojis.shuffled().prefix(count))
        }
    }
    
    func emptyAttempt() -> Bool {
        for index in guess.pegs.indices {
            if guess.pegs[index] != Code.missingPeg {
                break
            }
            
            if(index == guess.pegs.count - 1) {
                return true
            }
        }
        return false
    }
    
    func attemptAlreadyMade() -> Bool {
        if attempts.contains(where: { $0.pegs == guess.pegs }) {
            return true
        }
        return false
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}


