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

struct MessageView: View {
    @Binding var messages: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Movement History")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(hex: "1A237E"))
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(messages.reversed(), id: \.self) { message in
                        Text(message)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color(hex: "1A237E").opacity(0.5))
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color(hex: "1A237E").opacity(0.3))
        .cornerRadius(10)
    }
}

struct MessageView_Preview: PreviewProvider {
    @State static var messages = [
        "You can only use one special move per turn.",
        "You've already rolled the dice this turn.",
        "Quantum Jump activated. Select a cell within 3 spaces to jump to.",
        "Player 1 rolled a 2. Tap on a valid cell to move."
    ]
    
    static var previews: some View {
        MessageView(messages: $messages)
            .frame(width: 250, height: 300)
            .previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
