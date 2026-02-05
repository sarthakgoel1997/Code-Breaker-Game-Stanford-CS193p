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
    "cyan": .cyan
]

extension String {
    var pegColor: Color? {
        supportedColors[self]
    }
}

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    var pegChoices: [Peg]
    var currentGame: GameType
    
    static let availableColors: [String] = Array(supportedColors.keys)
    static let availableEmojis: [String] = ["🙂", "📁", "🚀", "🔥", "😂", "🐕", "🚗", "⚽️"]
    
    enum GameType {
        case color
        case emoji
    }
    
    init(pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
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
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        if emptyAttempt() || attemptAlreadyMade() {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func restart() {
        randomizePegChoices()
        
        let newPegsCount = Int.random(in: 3...6)
        masterCode.randomize(from: pegChoices, pegsCount: newPegsCount)
        guess.resetPegs(pegsCount: newPegsCount)
        attempts.removeAll()
        
        print(masterCode)
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
        if attempts.contains(where: { attempt in
            attempt.pegs == guess.pegs
        }) {
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


