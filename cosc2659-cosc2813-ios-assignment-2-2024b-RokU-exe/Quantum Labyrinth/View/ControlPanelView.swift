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

struct ControlPanelView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.03) {
                Spacer()
                QuantumButton(title: "Roll Dice", action: gameViewModel.rollDie)
                QuantumButton(title: "Quantum Jump (-3)", action: gameViewModel.quantumJump)
                    .disabled(gameViewModel.currentPlayer.quantumEnergy < 3)
                QuantumButton(title: "Superposition (-2)", action: gameViewModel.superposition)
                    .disabled(gameViewModel.currentPlayer.quantumEnergy < 2)
                QuantumButton(title: "Tunneling (-4)", action: gameViewModel.tunneling)
                    .disabled(gameViewModel.currentPlayer.quantumEnergy < 4)
                QuantumButton(title: "End Turn", action: gameViewModel.endTurn)
                Spacer()
            }
            .padding(geometry.size.width * 0.05)
        }
        .background(Color(hex: "1A237E").opacity(0.5))
        .cornerRadius(10)
    }
}

struct ControlPanelView_Preview: PreviewProvider {
    static var previews: some View {
        ControlPanelView(gameViewModel: GameViewModel())
    }
}
