import Foundation
import SwiftUI

struct InstructionsView1: View {
    var body: some View {
        ZStack {
            Color(.blueBlackground)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("HEY!  WELCOME TO CHAOS!")
                    .padding(.vertical)
                
                Text("ON THIS MULTIPLAYER GAME, COMMUNICATION IS KEY!")
                    .lineLimit(2)
                    .padding(.bottom)
            }
            .font(.custom("LuckiestGuy-Regular", size: 24))
            .foregroundColor(Color(.colorText))
        }
        .ignoresSafeArea()
    }
}
