/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Le Xuan Loc
  ID: s3955317
  Created  date: 12/08/2024
  Last modified: 02/09/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct GameBoardView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<Constants.Board.size, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<Constants.Board.size, id: \.self) { column in
                        CellView(cellType: gameViewModel.gameBoard.cells[row][column],
                                 isValidMove: gameViewModel.validMoves.contains(where: { $0 == (column, row) }))
                            .onTapGesture {
                                gameViewModel.movePlayer(to: (column, row))
                            }
                    }
                }
            }
        }
        .padding(8)
                .background(
                    LinearGradient(gradient: Gradient(colors: [QuantumColors.quantumDark, QuantumColors.quantumGray]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(QuantumColors.quantumBlue.opacity(0.5), lineWidth: 2)
                )
                .cornerRadius(15)
                .shadow(color: QuantumColors.quantumBlue.opacity(0.3), radius: 20, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(QuantumColors.quantumBlue, lineWidth: 1)
                        .blur(radius: 4)
                        .opacity(0.7)
        )
    }
}

struct GameBoardView_Preview: PreviewProvider {
    static var previews: some View {
        GameBoardView(gameViewModel: GameViewModel())
            .previewLayout(.fixed(width: 400, height: 400))
            .preferredColorScheme(.dark)
    }
}
