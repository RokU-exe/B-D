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

struct TimerView: View {
    let remainingTime: Int
    
    var body: some View {
        Text(timeString(from: remainingTime))
            .font(.headline)
            .padding(5)
            .background(Color.black.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(5)
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct TimerView_Preview: PreviewProvider{
    static var previews: some View{
        TimerView(remainingTime: 900)
    }
}
