//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 12/13/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode, gameType: game.currentGame)
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, gameType: game.currentGame, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt, gameType: game.currentGame) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver {
                PegChooser(choices: game.pegChoices, currentGame: game.currentGame, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                restartButton
            }
            
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                    .monospaced()
                    .lineLimit(1)
            }
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
    var restartButton: some View {
        Button("Restart Game", systemImage: "arrow.circlepath", action: restart)
        .font(.title2)
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: ["blue", "red", "orange"])
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
