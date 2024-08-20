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
import Combine
import Foundation

class GameViewModel: ObservableObject {
    @Published var gameBoard: GameBoard
    @Published var gameMode: GameMode = .standard
    @Published var remainingTime: Int = Constants.GameMode.timedModeDuration
    @Published var players: [Player]
    @Published var currentPlayerIndex: Int = 0
    @Published var gameState: GameState = .notStarted
    @Published var currentRoll: Int = 0
    @Published var message: String = ""
    @Published var validMoves: [(x: Int, y: Int)] = []
    @Published var canRollDice: Bool = true
    @Published var movesMade: Int = 0
    @Published var specialMovesUsed: [SpecialMove: Int] = [.quantumJump: 0, .superposition: 0, .tunneling: 0]
    @Published var isGameOver: Bool = false
    
    private var timer: Timer?
    private var activeSpecialMove: SpecialMove?
    private var specialMoveUsed: Bool = false
    
    var currentPlayer: Player {
        get { players[currentPlayerIndex] }
        set { players[currentPlayerIndex] = newValue }
    }
    
    enum SpecialMove: String {
        case quantumJump = "Quantum Jump"
        case superposition = "Superposition"
        case tunneling = "Tunneling"
    }
    
    init() {
        self.gameBoard = GameBoard(size: Constants.Board.size)
        self.players = [
            Player(id: "Player 1", position: (0, 0), cellType: .player1),
            Player(id: "Player 2", position: (0, 1), cellType: .player2)
        ]
        setupGame()
    }
    
    func setupGame() {
        gameBoard = GameBoard(size: Constants.Board.size)
        
        // Reset and reposition players
        players[0].reset()
        players[0].position = (0, 0)
        players[1].reset()
        players[1].position = (0, 1)
        
        currentPlayerIndex = 0
        gameState = .inProgress
        canRollDice = true
        specialMoveUsed = false
        activeSpecialMove = nil
        currentRoll = 0
        movesMade = 0
        specialMovesUsed = [.quantumJump: 0, .superposition: 0, .tunneling: 0]
        
        placeGameElements()
        gameBoard.setupInitialPositions(for: players)
        message = "It's \(currentPlayer.id)'s turn. Roll the dice to begin."
        
        print("Game setup complete. Player energies: \(players[0].quantumEnergy), \(players[1].quantumEnergy)")
    }
    
    private func placeGameElements() {
        // Place walls
        for _ in 0..<Constants.Board.wallCount {
            let x = Int.random(in: 0..<Constants.Board.size)
            let y = Int.random(in: 0..<Constants.Board.size)
            if (x, y) != (0, 0) && (x, y) != (0, 1) && (x, y) != (Constants.Board.size - 1, Constants.Board.size - 1) {
                gameBoard.cells[y][x] = .wall
            }
        }
        
        // Place energy cells and point tokens
        placeRandomly(cellType: .energyCell, count: Constants.Board.energyCellCount)
        placeRandomly(cellType: .pointToken, count: Constants.Board.pointTokenCount)
        
        // Place exit
        gameBoard.cells[Constants.Board.size - 1][Constants.Board.size - 1] = .exit
    }
    
    private func placeRandomly(cellType: CellType, count: Int) {
        var placed = 0
        while placed < count {
            let x = Int.random(in: 0..<Constants.Board.size)
            let y = Int.random(in: 0..<Constants.Board.size)
            if gameBoard.cells[y][x] == .empty {
                gameBoard.cells[y][x] = cellType
                placed += 1
            }
        }
    }
    
    func rollDie() {
        guard canRollDice else {
            message = "You've already rolled the dice this turn."
            return
        }
        
        currentRoll = Int.random(in: 1...6)
        message = "\(currentPlayer.id) rolled a \(currentRoll). Tap on a valid cell to move."
        updateValidMoves()
        canRollDice = false
    }
    
    private func updateValidMoves() {
        validMoves = []
        for y in 0..<Constants.Board.size {
            for x in 0..<Constants.Board.size {
                if isValidMove(to: (x, y)) {
                    validMoves.append((x, y))
                }
            }
        }
    }
    
    func movePlayer(to newPosition: (x: Int, y: Int)) {
        if case .quantumJump = activeSpecialMove {
            performQuantumJump(to: newPosition)
            return
        }
        
        movesMade += 1
        
        guard isValidMove(to: newPosition) else {
            message = "Invalid move. Try again."
            return
        }
        
        let moveDistance = abs(newPosition.x - currentPlayer.position.x) + abs(newPosition.y - currentPlayer.position.y)
        currentRoll -= moveDistance
        
        gameBoard.setCell(at: currentPlayer.position, to: .empty)
        currentPlayer.position = newPosition
        checkCellEffect(at: newPosition)
        gameBoard.setCell(at: newPosition, to: currentPlayer.cellType)
        
        incrementMovesMade()
        
        if currentRoll == 0 {
            applySpecialMoveEffectIfNeeded()
            checkWinCondition()
            if !isGameOver {
                endTurn()
            }
        } else {
            message = "\(currentPlayer.id) has \(currentRoll) moves left. Tap 'End Turn' to finish your turn."
            updateValidMoves()
        }

        checkWinCondition()
    }
    
    func isValidMove(to newPosition: (x: Int, y: Int)) -> Bool {
        let (startX, startY) = currentPlayer.position
        let (endX, endY) = newPosition
        
        // Check if the move is vertical or horizontal
        guard startX == endX || startY == endY else { return false }
        
        // Check if the move is within the current roll range
        let distance = abs(endX - startX) + abs(endY - startY)
        guard distance <= currentRoll && distance > 0 else { return false }
        
        // Check if the move is within board boundaries
        guard gameBoard.isWithinBounds(newPosition) else { return false }
        
        // Check for obstacles in the path
        if case .tunneling = activeSpecialMove {
            // When tunneling, allow passing through one wall, but not through other player
            return pathHasAtMostOneWallAndNoPlayer(from: (startX, startY), to: (endX, endY))
        } else {
            // Normal movement: path must be clear of walls and other player
            return pathIsClear(from: (startX, startY), to: (endX, endY))
        }
    }
    
    private func pathIsClear(from start: (x: Int, y: Int), to end: (x: Int, y: Int)) -> Bool {
        let (startX, startY) = start
        let (endX, endY) = end
        
        if startX == endX {
            // Vertical movement
            let range = startY < endY ? startY+1...endY : endY...startY-1
            return range.allSatisfy { y in
                let cell = gameBoard.cells[y][startX]
                return cell != .wall && !isPlayerCell(cell)
            }
        } else {
            // Horizontal movement
            let range = startX < endX ? startX+1...endX : endX...startX-1
            return range.allSatisfy { x in
                let cell = gameBoard.cells[startY][x]
                return cell != .wall && !isPlayerCell(cell)
            }
        }
    }
    
    private func pathHasAtMostOneWall(from start: (x: Int, y: Int), to end: (x: Int, y: Int)) -> Bool {
        let (startX, startY) = start
        let (endX, endY) = end
        var wallCount = 0
        
        if startX == endX {
            // Vertical movement
            let range = startY < endY ? startY+1...endY : endY...startY-1
            for y in range {
                if gameBoard.cells[y][startX] == .wall {
                    wallCount += 1
                    if wallCount > 1 { return false }
                }
            }
        } else {
            // Horizontal movement
            let range = startX < endX ? startX+1...endX : endX...startX-1
            for x in range {
                if gameBoard.cells[startY][x] == .wall {
                    wallCount += 1
                    if wallCount > 1 { return false }
                }
            }
        }
        
        return true
    }
    
    private func pathHasAtMostOneWallAndNoPlayer(from start: (x: Int, y: Int), to end: (x: Int, y: Int)) -> Bool {
        let (startX, startY) = start
        let (endX, endY) = end
        var wallCount = 0
        
        if startX == endX {
            // Vertical movement
            let range = startY < endY ? startY+1...endY : endY...startY-1
            for y in range {
                let cell = gameBoard.cells[y][startX]
                if cell == .wall {
                    wallCount += 1
                    if wallCount > 1 { return false }
                } else if isPlayerCell(cell) {
                    return false
                }
            }
        } else {
            // Horizontal movement
            let range = startX < endX ? startX+1...endX : endX...startX-1
            for x in range {
                let cell = gameBoard.cells[startY][x]
                if cell == .wall {
                    wallCount += 1
                    if wallCount > 1 { return false }
                } else if isPlayerCell(cell) {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func isPlayerCell(_ cell: CellType) -> Bool {
        return cell == .player1 || cell == .player2
    }
    
    
    
    private func checkCellEffect(at position: (x: Int, y: Int)) {
        guard let cellType = gameBoard.cellAt(position) else { return }
        switch cellType {
        case .energyCell:
            currentPlayer.quantumEnergy += Constants.CellEffect.energyCellBoost
            message = "\(currentPlayer.id) gained \(Constants.CellEffect.energyCellBoost) Quantum Energy!"
        case .pointToken:
            currentPlayer.score += Constants.CellEffect.pointTokenValue
            message = "\(currentPlayer.id) collected a point token!"
        case .exit:
            gameState = .finished
            message = "Congratulations! \(currentPlayer.id) reached the exit!"
        default:
            break
        }
    }
    
    func quantumJump() {
        guard canUseSpecialMove() else { return }
        
        activeSpecialMove = .quantumJump
        incrementSpecialMoveUsed(.quantumJump)
        applyEnergyCost(for: .quantumJump)
        message = "Quantum Jump activated. Select a cell within \(Constants.SpecialMove.quantumJumpMaxDistance) spaces to jump to."
        updateValidMovesForQuantumJump()
    }
    
    private func updateValidMovesForQuantumJump() {
        validMoves = []
        let (playerX, playerY) = currentPlayer.position
        let jumpRange = -Constants.SpecialMove.quantumJumpMaxDistance...Constants.SpecialMove.quantumJumpMaxDistance
        
        for dx in jumpRange {
            for dy in jumpRange {
                let newX = playerX + dx
                let newY = playerY + dy
                if gameBoard.isWithinBounds((newX, newY)) &&
                    gameBoard.cellAt((newX, newY)) != .wall &&
                    !isPlayerCell(gameBoard.cellAt((newX, newY))!) &&
                    (dx != 0 || dy != 0) {
                    validMoves.append((newX, newY))
                }
            }
        }
    }
    
    private func performQuantumJump(to newPosition: (x: Int, y: Int)) {
        guard validMoves.contains(where: { $0 == newPosition }) else {
            message = "Invalid quantum jump. Try again."
            return
        }
        
        applyEnergyCost(for: .quantumJump)
        gameBoard.setCell(at: currentPlayer.position, to: .empty)
        currentPlayer.position = newPosition
        checkCellEffect(at: newPosition)
        gameBoard.setCell(at: newPosition, to: currentPlayer.cellType)
        
        message = "Quantum jump successful!"
        activeSpecialMove = nil
        validMoves = []
        checkWinCondition()
        endTurn()
    }
    
    func superposition() {
        guard canUseSpecialMove() else { return }
        
        activeSpecialMove = .superposition
        incrementSpecialMoveUsed(.superposition)
        applyEnergyCost(for: .superposition)
        currentRoll += Constants.SpecialMove.superpositionExtraSpaces
        message = "Superposition activated. You can move \(Constants.SpecialMove.superpositionExtraSpaces) extra spaces this turn."
        updateValidMoves()
    }
    
    func tunneling() {
        guard canUseSpecialMove() else { return }
        
        activeSpecialMove = .tunneling
        applyEnergyCost(for: .tunneling)
        incrementSpecialMoveUsed(.tunneling)
        message = "Tunneling activated. You can move through one wall this turn."
        updateValidMoves()
    }
    
    func endTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        currentRoll = 0
        activeSpecialMove = nil
        validMoves = []
        canRollDice = true
        specialMoveUsed = false
        message = "It's \(currentPlayer.id)'s turn. Roll the dice to begin."
        
        // Debug print
        print("Turn ended. Player energies: \(players[0].quantumEnergy), \(players[1].quantumEnergy)")
    }
    
    private func canUseSpecialMove() -> Bool {
        guard activeSpecialMove == nil else {
            message = "You can only use one special move per turn."
            return false
        }
        guard !canRollDice else {
            message = "You must roll the dice before using a special move."
            return false
        }
        guard currentPlayer.quantumEnergy >= minSpecialMoveCost() else {
            message = "Not enough Quantum Energy for any special move."
            return false
        }
        return true
    }
    
    private func minSpecialMoveCost() -> Int {
        return min(Constants.SpecialMove.quantumJumpCost,
                   Constants.SpecialMove.superpositionCost,
                   Constants.SpecialMove.tunnelingCost)
    }
    
    private func applyEnergyCost(for specialMove: SpecialMove) {
        guard !specialMoveUsed else { return }
        
        let cost: Int
        switch specialMove {
        case .quantumJump: cost = Constants.SpecialMove.quantumJumpCost
        case .superposition: cost = Constants.SpecialMove.superpositionCost
        case .tunneling: cost = Constants.SpecialMove.tunnelingCost
        }
        
        let oldEnergy = currentPlayer.quantumEnergy
        currentPlayer.quantumEnergy = max(0, currentPlayer.quantumEnergy - cost)
        specialMoveUsed = true
        
        // Debug print
        print("\(currentPlayer.id) used \(specialMove). Energy: \(oldEnergy) -> \(currentPlayer.quantumEnergy)")
    }
    
    private func applySpecialMoveEffectIfNeeded() {
        guard let specialMove = activeSpecialMove, !specialMoveUsed else { return }
        applyEnergyCost(for: specialMove)
    }
    
    private func checkWinCondition() {
        if currentPlayer.position == (Constants.Board.size - 1, Constants.Board.size - 1) {
            gameState = .finished
            message = "Congratulations! \(currentPlayer.id) reached the exit with \(currentPlayer.score) points!"
        }
    }
    
    func startTimedMode() {
        setupGame()
        gameMode = .timed
        remainingTime = Constants.GameMode.timedModeDuration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        remainingTime -= 1
        if remainingTime <= 0 {
            endTimedMode()
        }
    }
    
    private func endTimedMode() {
        timer?.invalidate()
        gameState = .finished
        let winner = players.max(by: { $0.score < $1.score })
        message = "Time's up! \(winner?.id ?? "No one") wins with \(winner?.score ?? 0) points."
    }
    
    func calculateFinalScore() -> Int {
        return players.map { $0.score + ($0.quantumEnergy / 2) }.max() ?? 0
    }
    
    private func incrementMovesMade() {
        movesMade += 1
    }
    
    private func incrementSpecialMoveUsed(_ move: SpecialMove) {
        specialMovesUsed[move, default: 0] += 1
    }
    
    func getSpecialMovesUsedStrings() -> [String: Int] {
        return [
            "Quantum Jump": specialMovesUsed[.quantumJump] ?? 0,
            "Superposition": specialMovesUsed[.superposition] ?? 0,
            "Tunneling": specialMovesUsed[.tunneling] ?? 0
        ]
    }
}
