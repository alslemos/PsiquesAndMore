//
//  Credits View.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import SwiftUI

struct CreditsView: View {

    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
    
    
    var body: some View {
        ZStack {
            Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
            
            
            VStack(alignment: .center, spacing: 0.0) {
                
                Text("Credits")
                    .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                    .padding(.bottom)
                
                Text("Alexandre Lemos")
                    .font(.custom("LuckiestGuy-Regular", size: 16)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                
                Text("Arthur Sobrosa")
                    .font(.custom("LuckiestGuy-Regular", size: 16)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                
                Text("Gustavo Silvano")
                    .font(.custom("LuckiestGuy-Regular", size: 16)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                
                Text("Victória Trindade")
                    .font(.custom("LuckiestGuy-Regular", size: 16)) //LuckiestGuy-Regular
                    .foregroundColor(semclique)
                    .padding(.all)
                
             
            }
        
        }.ignoresSafeArea()
        
    }
}
