//
//  PersonalizedBack.swift
//  FonoAndFamily
//
//  Created by Alexandre Lemos da Silva on 08/08/23.
//

import SwiftUI

struct CustomJumpButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationLink {
//            InitialScreenView()
//                .navigationBarBackButtonHidden(true)
        } label: {
            HStack {
                Text("SKIP")
                    .font(.custom("LuckiestGuy-Regular", size: 24))
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
