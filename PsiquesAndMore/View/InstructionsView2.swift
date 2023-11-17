import Foundation
import SwiftUI

struct InstructionsView2: View {
    var fundo = Color(red: 33/255, green: 60/255, blue: 85/255)
    var clique = Color(red: 253/255, green: 169/255, blue: 101/255)
    var semclique = Color(red: 255/255, green: 236/255, blue: 215/255)
    
    @State var showInstruction3 : Bool = false
    
    var body: some View {
        ZStack {
            fundo
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("For each adventure, you and your pair must control")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                Text("YOUR OWN JOYSTICKS TO reach the end of the timer")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                VStack {
                    Button("Next") {
                        showInstruction3 = true
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(clique)
                .navigationDestination(isPresented:  $showInstruction3) {
                    VStack {
                        InstructionsView3().ignoresSafeArea().navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: CustomBackButton())
                            .navigationBarItems(trailing: CustomJumpButton())
                    }
                }
            }
        }.ignoresSafeArea()
    }
}
