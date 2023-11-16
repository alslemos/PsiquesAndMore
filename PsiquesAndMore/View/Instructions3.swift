//
//  Credits View.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import SwiftUI

struct Instructions3: View {
    
    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
    @State var showInstruction4 : Bool = false
    
    var body: some View {
        
        ZStack {
            Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
            
            
            VStack(alignment: .center, spacing: 0.0) {
                
                Text("Each adventure has a new scenario, with different")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                
                Text("mechanics and many badges to discover")
                    .lineLimit(2)
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                VStack {
                    Button("Enjoy") {
                        showInstruction4 = true
//                        shouldShowOnboarding.toggle()
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                .foregroundColor(clique)
                .navigationDestination(isPresented:  $showInstruction4) {
                    VStack {
                        //   FirstView(matchManager: _matchManager).ignoresSafeArea().navigationBarBackButtonHidden(true)
                           
                    }
                }
        
            }
        
        }.ignoresSafeArea()
        
    }
}
