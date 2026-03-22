//
//  PegView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 2/2/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let currentGame: CodeBreaker.GameType
    let isHidden: Bool
    
    
    // MARK: - Body
    
    func coloredPeg() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg.pegColor ?? .clear)
            .opacity(isHidden ? 0 : 1)
    }
    
    func emoji() -> some View {
        Text(peg)
            .font(.system(size: 120))
            .minimumScaleFactor(9/120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .opacity(isHidden ? 0 : 1)
    }
    
    var body: some View {
        if currentGame == .color {
            coloredPeg()
        } else {
            emoji()
        }
    }
}

#Preview {
    PegView(peg: "blue", currentGame: .color, isHidden: false)
        .padding()
}
