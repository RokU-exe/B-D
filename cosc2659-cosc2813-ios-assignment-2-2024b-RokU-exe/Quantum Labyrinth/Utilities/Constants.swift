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

enum Constants {
    enum Board {
        static let size = 10
        static let wallCount = 20
        static let energyCellCount = 7
        static let pointTokenCount = 15
    }
    
    enum Player {
        static let initialQuantumEnergy = 10
        static let initialScore = 0
    }
    
    enum SpecialMove {
        static let quantumJumpCost = 3
        static let superpositionCost = 2
        static let tunnelingCost = 4
        static let superpositionExtraSpaces = 2
        static let quantumJumpMaxDistance = 3
    }
    
    enum GameMode {
        static let timedModeDuration = 900 // 15 minutes in seconds
    }
    
    enum CellEffect {
        static let energyCellBoost = 3
        static let pointTokenValue = 1
    }
}
