import Foundation
import SwiftUI

struct InstructionsView2: View {

    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
    @State var showInstruction3 : Bool = false
//    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    var body: some View {
        ZStack {
            Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
            
            
            VStack(alignment: .center, spacing: 0.0) {
                
                Text("For each adventure, you and you pare must control")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                Text("ITS OWN JOYSTICKS,  FOR reach the end of the timer")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                
                VStack {
                    Button("Next") {
                        showInstruction3 = true
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                .foregroundColor(clique)
                .navigationDestination(isPresented:  $showInstruction3) {
                    VStack {
                        InstructionsView3().ignoresSafeArea().navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: CustomBackButton()) // Usando nosso botão personalizado no lugar
                            .navigationBarItems(trailing: CustomJumpButton())
                    }
                }
                
                
             
            }
        
        }.ignoresSafeArea()
        
    }
}
