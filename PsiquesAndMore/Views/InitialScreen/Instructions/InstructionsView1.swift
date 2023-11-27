import Foundation
import SwiftUI

struct InstructionsView1: View {
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("HEY!  WELCOME TO CHAOS!")
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.vertical)
                
                Text("ON THIS MULTIPLAYER GAME, COMMUNICATION IS KEY!")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.bottom)
            }
        }
        .ignoresSafeArea()
    }
}
