//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 6/7/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List($games, id: \.pegChoices, editActions: [.move, .delete]) { $game in
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameSummary(game: game)
                }
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: ["red", "blue", "green", "yellow"]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: ["orange", "brown", "black", "yellow", "green"]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: ["blue", "indigo", "cyan"]))
        }
    }
}

#Preview {
    GameChooser()
}
