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

struct ContentView: View {
    @StateObject private var gameViewModel: GameViewModel
    @State private var gameMode: GameMode = .standard
    @State private var showSetup = true
    @State private var showGameOver = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var messageHistory: [String] = []

    init() {
        _gameViewModel = StateObject(wrappedValue: GameViewModel())
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if showSetup {
                    SetupView(gameMode: $gameMode, startGame: startGame)
                        .transition(.opacity)
                } else if showGameOver {
                    GameOverView(
                        winner: gameViewModel.currentPlayer.id,
                        score: gameViewModel.calculateFinalScore(),
                        movesMade: gameViewModel.movesMade,
                        specialMovesUsed: gameViewModel.getSpecialMovesUsedStrings(),
                        restartGame: restartGame,
                        returnToHome: returnToHome
                    )
                    .transition(.opacity)
                } else {
                    gameView(geometry: geometry)
                }
            }
            .animation(.easeInOut, value: showSetup)
            .animation(.easeInOut, value: showGameOver)
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .onChange(of: gameViewModel.gameState) { _, newState in
            if newState == .finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showGameOver = true
                }
                playSound("game_over.mp3")
            }
        }
        .onChange(of: gameViewModel.message) { _, newMessage in
            addMessageToHistory(newMessage)
        }
        .onAppear {
            setupAudioPlayer()
        }
    }
    
    @ViewBuilder
    private func gameView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            StatusPanelView(player: gameViewModel.currentPlayer, currentPlayer: gameViewModel.currentPlayer.id)
                .frame(height: geometry.size.height * 0.08)
            
            HStack(spacing: 20) {
                MessageView(messages: $messageHistory)
                    .frame(width: geometry.size.width * 0.25)
                
                GameBoardView(gameViewModel: gameViewModel)
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.8)
                
                ControlPanelView(gameViewModel: gameViewModel)
                    .frame(width: geometry.size.width * 0.25)
            }
            .frame(height: geometry.size.height * 0.9)
        }
        .padding(10)
        .background(Color(hex: "1A237E").opacity(0.3))
    }
    
    private func startGame() {
        showSetup = false
        if gameMode == .timed {
            gameViewModel.startTimedMode()
        } else {
            gameViewModel.setupGame()
        }
        playSound("game_start.mp3")
    }

    private func restartGame() {
        showGameOver = false
        gameViewModel.setupGame()
        messageHistory.removeAll()
        playSound("game_restart.mp3")
    }
    
    private func returnToHome() {
        showGameOver = false
        showSetup = true
        messageHistory.removeAll()
        playSound("return_home.mp3")
    }

    private func setupAudioPlayer() {
        guard let sound = Bundle.main.path(forResource: "background_music", ofType: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.play()
        } catch {
            print("Couldn't load background music")
        }
    }

    private func playSound(_ soundName: String) {
        guard let sound = Bundle.main.path(forResource: soundName, ofType: nil) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            player.play()
        } catch {
            print("Couldn't play sound effect: \(soundName)")
        }
    }

    private func addMessageToHistory(_ message: String) {
        messageHistory.append(message)
        if messageHistory.count > 10 {
            messageHistory.removeFirst()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
