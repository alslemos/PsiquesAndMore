import Foundation
import SwiftUI

struct InstructionsView2: View {
    var body: some View {
        ZStack {
            Color(.blueBlackground)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("FOR EACH ADVENTURE, YOU AND YOUR PAIR MUST CONTROL")
                    .lineLimit(2)
                    .padding(.vertical)
                
                Text("YOUR OWN JOYSTICKS TO REACH THE END OF THE TIMER")
                    .lineLimit(2)
                    .padding(.bottom)
            }
            .font(.custom("LuckiestGuy-Regular", size: 24))
            .foregroundColor(Color(.colorText))
        }
        .ignoresSafeArea()
    }
}
