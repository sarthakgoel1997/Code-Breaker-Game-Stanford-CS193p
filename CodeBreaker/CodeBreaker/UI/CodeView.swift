//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 2/3/26.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    let gameType: CodeBreaker.GameType
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    init(
        code: Code,
        gameType: CodeBreaker.GameType, selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self.gameType = gameType
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index], currentGame: gameType)
                    .padding(Selection.border)
                    .background {
                        if selection == index, code.kind == .guess {
                            Selection.shape
                                .foregroundStyle(Selection.color)
                        }
                    }
                    .overlay {
                        Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            
            Rectangle()
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray(0.8)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

//#Preview {
//    CodeView()
//}
