import Foundation
import SwiftUI

struct InstructionsView2: View {
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("FOR EACH ADVENTURE, YOU AND YOUR PAIR MUST CONTROL")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(Color(.semclique))
                    .padding(.vertical)
                
                Text("YOUR OWN JOYSTICKS TO REACH THE END OF THE TIMER")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.bottom)
            }
        }
        .ignoresSafeArea()
    }
}
