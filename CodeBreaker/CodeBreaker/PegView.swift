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
    
    
    // MARK: - Body
    
    func coloredPeg() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if peg == Code.missingPeg {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg.pegColor ?? .clear)
    }
    
    func emoji() -> some View {
        Text(peg)
            .font(.system(size: 120))
            .minimumScaleFactor(9/120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if(peg == Code.missingPeg) {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                }
            }
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
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
    PegView(peg: "blue", currentGame: .color)
        .padding()
}
