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
import AVFoundation

struct GameOverView: View {
    let winner: String
    let score: Int
    let movesMade: Int
    let specialMovesUsed: [String: Int]
    let restartGame: () -> Void
    let returnToHome: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [QuantumColors.background, QuantumColors.tertiary]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 30) {
                Text("Game Over")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(QuantumColors.primary)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Winner: \(winner)")
                    Text("Final Score: \(score)")
                    Text("Moves Made: \(movesMade)")
                    
                    Text("Special Moves Used:")
                    ForEach(specialMovesUsed.sorted(by: { $0.key < $1.key }), id: \.key) { move, count in
                        Text("• \(move): \(count)")
                            .padding(.leading)
                    }
                }
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(QuantumColors.secondary)
                .padding()
                .background(QuantumColors.background.opacity(0.5))
                .cornerRadius(15)
                
                HStack(spacing: 20) {
                    QuantumButton(title: "Play Again", action: restartGame)
                    QuantumButton(title: "Home", action: returnToHome)
                }
            }
            .padding()
            .background(QuantumColors.background.opacity(0.7))
            .cornerRadius(25)
            .shadow(color: QuantumColors.primary.opacity(0.5), radius: 20, x: 0, y: 0)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(
            winner: "Player 1",
            score: 100,
            movesMade: 25,
            specialMovesUsed: ["Quantum Jump": 3, "Superposition": 2, "Tunneling": 1],
            restartGame: {},
            returnToHome: {}
        )
    }
}
