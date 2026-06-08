//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 6/7/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices, currentGame: game.currentGame)
                .frame(maxHeight: 50)
            
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List{
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: ["red", "cyan", "yellow"]))
    }
    
    List{
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: ["red", "cyan", "yellow"]))
    }
    .listStyle(.plain)
}
