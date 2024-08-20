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

struct CellView: View {
    let cellType: CellType
    let isValidMove: Bool
    
    var body: some View {
        ZStack {
            if cellType == .player1 || cellType == .player2 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(cellType == .player1 ? QuantumColors.quantumBlue : QuantumColors.quantumPurple, lineWidth: 2)
                    )
                    .shadow(color: cellType == .player1 ? QuantumColors.quantumBlue.opacity(0.6) : QuantumColors.quantumPurple.opacity(0.6), radius: 4, x: 0, y: 0)
            } else {
                Rectangle()
                    .fill(backgroundColor)
                    .border(QuantumColors.quantumGray, width: 0.5)
            }

            Image(systemName: imageName)
                .foregroundColor(imageColor)
                .font(.system(size: 14))

            if isValidMove {
                RoundedRectangle(cornerRadius: 8)
                    .fill(QuantumColors.quantumBlue.opacity(0.3))
                    .padding(4)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        switch cellType {
        case .empty: return QuantumColors.quantumDark.opacity(0.7)
        case .wall: return QuantumColors.quantumGray
        case .energyCell: return QuantumColors.quantumGreen.opacity(0.7)
        case .pointToken: return QuantumColors.quantumOrange.opacity(0.7)
        case .player1: return QuantumColors.quantumBlue.opacity(0.7)
        case .player2: return QuantumColors.quantumPurple.opacity(0.7)
        case .exit: return QuantumColors.quantumGreen.opacity(0.7)
        }
    }
    
    private var imageName: String {
        switch cellType {
        case .player1: return "person.fill"
        case .player2: return "person.2.fill"
        case .energyCell: return "bolt.fill"
        case .pointToken: return "star.fill"
        case .exit: return "flag.fill"
        default: return ""
        }
    }
    
    private var imageColor: Color {
        switch cellType {
        case .player1, .player2: return .white
        case .energyCell: return QuantumColors.quantumGreen
        case .pointToken: return QuantumColors.quantumOrange
        case .exit: return QuantumColors.quantumGray
        default: return .clear
        }
    }
}
