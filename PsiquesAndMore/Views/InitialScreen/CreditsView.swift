//
//  Credits View.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import SwiftUI

struct CreditsView: View {
    let names: [String] = ["Alexandre Lemos", "Arthur Sobrosa", "Gustavo Silvano", "Victoria Trindade"]
    
    var body: some View {
        ZStack {
            Color(.blueBlackground)
            
            VStack(spacing: 24) {
                Text("Credits")
                    .font(.custom("LuckiestGuy-Regular", size: 24))
                    .padding(.bottom)
                
                ForEach(names, id: \.self) { name in
                    Text(name)
                }
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))
            .foregroundColor(Color(.colorText))
        }
        .ignoresSafeArea()
    }
}
