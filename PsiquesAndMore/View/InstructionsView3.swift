import Foundation
import SwiftUI

struct InstructionsView3: View {
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("Each adventure has a new scenario, with different")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.vertical)
                
                Text("mechanics and many badges to discover!")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.bottom)
            }
        }
        .ignoresSafeArea()
    }
}
