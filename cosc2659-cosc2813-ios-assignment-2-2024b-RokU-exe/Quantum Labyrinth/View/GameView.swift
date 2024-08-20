//
//  GameView.swift
//  Quantum Labyrinth
//
//  Created by Xuan Loc on 19/8/24.
//

import Foundation
import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @State private var messageHistory: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                // Status Panel
                StatusPanelView(player: gameViewModel.currentPlayer, currentPlayer: gameViewModel.currentPlayer.id)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    // Message History
                    MessageView(messages: $messageHistory)
                        .frame(width: geometry.size.width * 0.25)
                    
                    // Game Board
                    GameBoardView(gameViewModel: gameViewModel)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.7)
                    
                    // Control Panel
                    VStack(spacing: 10) {
                        ControlPanelView(gameViewModel: gameViewModel)
                        
                        if gameViewModel.gameMode == .timed {
                            TimerView(remainingTime: gameViewModel.remainingTime)
                        }
                    }
                    .frame(width: geometry.size.width * 0.25)
                }
                .padding(.horizontal)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .onChange(of: gameViewModel.message) { _, newMessage in
            addMessageToHistory(newMessage)
        }
    }
    
    private func addMessageToHistory(_ message: String) {
        messageHistory.append(message)
        if messageHistory.count > 10 {
            messageHistory.removeFirst()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameViewModel: GameViewModel())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
