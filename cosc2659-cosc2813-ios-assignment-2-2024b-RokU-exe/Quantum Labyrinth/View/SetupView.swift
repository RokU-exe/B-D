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
import AVFoundation

struct SetupView: View {
    @Binding var gameMode: GameMode
    let startGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quantum Labyrinth")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Picker("Game Mode", selection: $gameMode) {
                Text("Standard").tag(GameMode.standard)
                Text("Timed").tag(GameMode.timed)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Start Game") {
                startGame()
            }
            .buttonStyle(QuantumButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .edgesIgnoringSafeArea(.all)
    }
}
