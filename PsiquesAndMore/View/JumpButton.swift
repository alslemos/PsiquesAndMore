//
//  PersonalizedBack.swift
//  FonoAndFamily
//
//  Created by Alexandre Lemos da Silva on 08/08/23.
//

import SwiftUI

struct CustomJumpButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    
    var body: some View {
        
        NavigationLink {
            InitialScreenView()
                .navigationBarBackButtonHidden(true)
        } label: {
            HStack {
                Text("JUMP")
                    .font(.custom("LuckiestGuy-Regular", size: 24))
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
