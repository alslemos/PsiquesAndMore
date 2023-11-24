import Foundation
import SwiftUI

struct InstructionsView2: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var showInstruction3 : Bool = false
    
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("For each adventure, you and your pair must control")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                    .padding(.bottom)
                
                Text("YOUR OWN JOYSTICKS TO reach the end of the timer")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                    .padding(.bottom)
                
                VStack {
                    Button("Next") {
                        showInstruction3 = true
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(Color(.clique))
                .navigationDestination(isPresented:  $showInstruction3) {
                    VStack {
                        InstructionsView3().ignoresSafeArea().navigationBarBackButtonHidden(true)
                    }
                }
            }
        }.ignoresSafeArea()
            .navigationBarItems(trailing: CustomJumpButton())
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(.clique))
                    }
                }
            )
    }
}
