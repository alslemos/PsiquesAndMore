import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrowshape.turn.up.backward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(clique)
              
            }
        }
    }
}

////  how to use it:
/**
 .navigationBarBackButtonHidden(true)
 .navigationBarItems(leading: CustomBackButton()) // Usando nosso botão personalizado no lugar
 */
