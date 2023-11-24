//
//  Credits View.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import SwiftUI

struct CreditsView: View {
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(alignment: .center, spacing: 0.0) {
                Text("Credits")
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                    .padding(.bottom)
                
                Text("Alexandre Lemos")
                    .font(.custom("LuckiestGuy-Regular", size: 16))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                
                Text("Arthur Sobrosa")
                    .font(.custom("LuckiestGuy-Regular", size: 16))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                
                Text("Gustavo Silvano")
                    .font(.custom("LuckiestGuy-Regular", size: 16))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
                
                Text("Victória Trindade")
                    .font(.custom("LuckiestGuy-Regular", size: 16))
                    .foregroundColor(Color(.semclique))
                    .padding(.all)
            }
        }.ignoresSafeArea()
        
    }
}
