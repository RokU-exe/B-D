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

struct QuantumButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                Text(title)
                    .font(.system(size: min(geometry.size.width * 0.08, 16), weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [QuantumColors.primary, QuantumColors.tertiary]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.7), lineWidth: 1)
            )
        }
    }
}

//struct QuantumButton: View {
//    let title: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.system(size: 24, weight: .bold, design: .rounded))
//                .foregroundColor(.white)
//                .frame(width: 200, height: 60)
//                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "00FFFF"), Color(hex: "0080FF")]), startPoint: .leading, endPoint: .trailing))
//                .cornerRadius(30)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 30)
//                        .stroke(Color.white, lineWidth: 2)
//                )
//                .shadow(color: Color(hex: "00FFFF").opacity(0.5), radius: 10, x: 0, y: 0)
//        }
//    }
//}
