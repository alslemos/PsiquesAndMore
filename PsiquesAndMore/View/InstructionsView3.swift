import Foundation
import SwiftUI

struct InstructionsView3: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var showInstruction4 : Bool = false
    
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("Each adventure has a new scenario, with different")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                    .padding(.bottom)
                
                Text("mechanics and many badges to discover")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                    .padding(.bottom)
                
                VStack {
                    Button("Enjoy") {
                        showInstruction4 = true
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(Color(.clique))
                .navigationDestination(isPresented:  $showInstruction4) {
                    VStack {
                        InitialScreenView().ignoresSafeArea().navigationBarBackButtonHidden(true)
                    }
                }
            }
        }.ignoresSafeArea()
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
