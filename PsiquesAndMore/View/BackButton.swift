import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
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
    }
}

////  how to use it:
/**
 .navigationBarBackButtonHidden(true)
 .navigationBarItems(leading: CustomBackButton()) // Usando nosso botão personalizado no lugar
 */
