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

import Foundation
import SwiftUI

struct StatusPanelView: View {
    let player: Player
    let currentPlayer: String
    
    var body: some View {
        HStack {
            StatusItemView(title: "Quantum Energy", value: "\(player.quantumEnergy)", imageName: "bolt.fill")
            Spacer()
            StatusItemView(title: "Score", value: "\(player.score)", imageName: "star.fill")
            Spacer()
            HStack {
                Text("Current Player:")
                    .foregroundColor(.white)
                Text(currentPlayer)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(hex: "4CAF50").opacity(0.7))
            .cornerRadius(8)
        }
        .padding(10)
        .background(Color(hex: "1A237E").opacity(0.5))
        .cornerRadius(10)
    }
}

struct StatusPanelView_Preview: PreviewProvider {
    static var previews: some View {
        StatusPanelView(player: Player(id: "Player 1", position: (0, 0), cellType: .player1), currentPlayer: "Player 1")
    }
}
