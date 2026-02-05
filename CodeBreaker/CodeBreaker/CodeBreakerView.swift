//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 12/13/25.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(pegChoices: ["🙂", "😂", "❤️", "📆", "📂", "✅"])
    @State private var selection: Int = 0
    
    // MARK: - Body
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            PegChooser(choices: game.pegChoices, currentGame: game.currentGame) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
            restartButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    var restartButton: some View {
        Button("Restart Game") {
            withAnimation {
                game.restart()
                selection = 0
            }
        }
        .font(.title2)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, gameType: game.currentGame, selection: $selection)
            
            Rectangle()
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers(matches: matches)
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = minimumFontSize / maximumFontSize
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
