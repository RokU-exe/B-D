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
class MockGameViewModel: GameViewModel {
    override init() {
        super.init()
        self.players = [
            Player(id: "Player 1", position: (0, 0), cellType: .player1),
            Player(id: "Player 2", position: (0, 1), cellType: .player2)
        ]
        self.currentPlayerIndex = 0
        self.message = "Mock game message"
    }
}
