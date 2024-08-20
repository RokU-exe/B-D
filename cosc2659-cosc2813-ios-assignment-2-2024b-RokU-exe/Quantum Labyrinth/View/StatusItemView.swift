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

struct StatusItemView: View {
    let title: String
    let value: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: imageName)
                .foregroundColor(Color(hex: "7C4DFF"))
            Text(value)
                .foregroundColor(Color(hex: "7C4DFF"))
                .fontWeight(.bold)
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 14))
        }
        .font(.system(size: 16))
    }
}
