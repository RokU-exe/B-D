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

enum CellType {
    case empty, wall, energyCell, pointToken, exit, player1, player2

    var isPlayer: Bool {
        switch self {
        case .player1, .player2:
            return true
        default:
            return false
        }
    }
}
