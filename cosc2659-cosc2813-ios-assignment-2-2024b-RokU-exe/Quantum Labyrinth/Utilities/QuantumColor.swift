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

struct QuantumColors {
    // Main colors from the palette
    static let quantumBlue = Color(hex: "007bff") // A vibrant blue, suggestive of energy
    static let quantumPurple = Color(hex: "9370DB") // A deeper purple, for a mysterious feel
    static let quantumGreen = Color(hex: "32CD32") // A bright green, for a sense of life and energy
    static let quantumOrange = Color(hex: "FF8C00") // A fiery orange, for intensity and excitement

    // Dark colors for contrast
    static let quantumDark = Color(hex: "121212") // A deep, almost black color
    static let quantumGray = Color(hex: "404040") // A neutral gray for balance

    // Game elements
    static let background = quantumDark
    static let primary = quantumBlue
    static let secondary = quantumPurple
    static let tertiary = quantumGreen
    static let quaternary = quantumOrange
    static let accent = quantumGray

    // Player colors
    static let player1 = quantumBlue
    static let player2 = quantumPurple

    // Cell colors
    static let empty = quantumDark.opacity(0.7)
    static let wall = quantumGray
    static let energyCell = quantumBlue.opacity(0.7)
    static let pointToken = quantumPurple.opacity(0.7)
    static let exit = quantumGreen.opacity(0.7)
}
