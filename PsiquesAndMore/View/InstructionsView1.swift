import Foundation
import SwiftUI

struct InstructionsView1: View {
    @State var showInstruction2 : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.fundo)
                
                VStack(alignment: .center, spacing: 0.0) {
                    Text("Hey!  Welcome to CHAOS!")
                        .font(.custom("LuckiestGuy-Regular", size: 24))
                        .foregroundColor(Color(.semclique))
                        .padding(.all)
                        .padding(.bottom)
                    
                    Text("ON THIS MULTIPLAYER GAME, COMMUNICATION IS KEY!")
                        .lineLimit(2)
                        .font(.custom("LuckiestGuy-Regular", size: 24))
                        .foregroundColor(Color(.semclique))
                        .padding(.all)
                    
                    VStack {
                        Button("Next") {
                            showInstruction2 = true
                        }
                        .font(.custom("LuckiestGuy-Regular", size: 24))
                        .foregroundColor(Color(.clique))
                    }
                    .navigationDestination(isPresented: $showInstruction2) {
                        VStack {
                            InstructionsView2().ignoresSafeArea().navigationBarBackButtonHidden(true)
                        }
                    }
                }
            }.ignoresSafeArea()
            .navigationBarItems(trailing: CustomJumpButton())
        }
    }
}
