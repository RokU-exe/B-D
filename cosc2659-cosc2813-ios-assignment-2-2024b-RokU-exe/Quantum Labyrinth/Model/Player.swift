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

struct Player: Identifiable {
    let id: String
    var position: (x: Int, y: Int)
    var quantumEnergy: Int
    var score: Int
    let cellType: CellType

    init(id: String, position: (x: Int, y: Int), cellType: CellType) {
        self.id = id
        self.position = position
        self.quantumEnergy = Constants.Player.initialQuantumEnergy
        self.score = 0
        self.cellType = cellType
    }
    
    mutating func reset(){
        quantumEnergy = Constants.Player.initialQuantumEnergy
        score = Constants.Player.initialScore
    }
}
