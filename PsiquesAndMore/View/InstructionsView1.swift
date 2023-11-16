import Foundation
import SwiftUI

struct InstructionsView1: View {
  
    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
  
    @State var showInstruction2 : Bool = false
    
//    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    var body: some View {
        ZStack {
            Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
            
            
            VStack(alignment: .center, spacing: 0.0) {
                
                Text("Hey!  Welcome to CHAOS!")
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                
                Text("ON THIS MULTIPLAYER GAME, THE COMMUNICATION IS KEY!")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                  
                VStack {
                    Button("Next") {
                        showInstruction2 = true
                        print("JORGEEE")
                    }
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(clique)
                }
                .navigationDestination(isPresented: $showInstruction2) {
                    VStack {
                        InstructionsView2().ignoresSafeArea().navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: CustomBackButton()) // Usando nosso botão personalizado no lugar
                            .navigationBarItems(trailing: CustomJumpButton())
                    }
                }
             
            }
        
        }
        
    }
}
