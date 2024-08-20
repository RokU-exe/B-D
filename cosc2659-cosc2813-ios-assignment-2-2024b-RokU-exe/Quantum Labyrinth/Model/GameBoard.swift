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

struct GameBoard {
    let size: Int
    var cells: [[CellType]]
    
    init(size: Int = Constants.Board.size) {
        self.size = size
        self.cells = Array(repeating: Array(repeating: .empty, count: size), count: size)
    }
    
    mutating func setupInitialPositions(for players: [Player]) {
        for player in players {
            cells[player.position.y][player.position.x] = player.cellType
        }
    }
    
    func isWithinBounds(_ position: (x: Int, y: Int)) -> Bool {
        return position.x >= 0 && position.x < size && position.y >= 0 && position.y < size
    }
    
    func cellAt(_ position: (x: Int, y: Int)) -> CellType? {
        guard isWithinBounds(position) else { return nil }
        return cells[position.y][position.x]
    }
    
    mutating func setCell(at position: (x: Int, y: Int), to cellType: CellType) {
        guard isWithinBounds(position) else { return }
        cells[position.y][position.x] = cellType
    }
    
    func isObstacle(at position: (x: Int, y: Int)) -> Bool {
        guard let cell = cellAt(position) else { return true }
        return cell == .wall || cell.isPlayer
    }
    
    func availableAdjacentPositions(from position: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        return directions.compactMap { dir -> (x: Int, y: Int)? in
            let newPos = (position.x + dir.0, position.y + dir.1)
            guard isWithinBounds(newPos) && !isObstacle(at: newPos) else { return nil }
            return newPos
        }
    }
}
