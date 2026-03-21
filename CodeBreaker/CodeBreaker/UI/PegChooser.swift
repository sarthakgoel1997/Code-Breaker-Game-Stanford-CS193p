//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 2/3/26.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data In
    let choices: [Peg]
    let currentGame: CodeBreaker.GameType
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg, currentGame: currentGame)
                }
            }
        }
    }
}

//#Preview {
//    PegChooser()
//}
