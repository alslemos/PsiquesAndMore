//
//  LoadingGameView.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 17/11/23.
//

import SwiftUI

struct LoadingGameView: View {
    
    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    
    @State var loadingText: String = "Loading"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            
            fundo.ignoresSafeArea()
            
            Text(loadingText)
                .lineLimit(2)
                .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                .foregroundColor(clique)
                .padding(.all)
        }
        .onReceive(timer) { input in
            if loadingText.count < 10 {
                loadingText += "."
            } else {
                loadingText = "Loading"
            }
        }
    }
}

#Preview {
    LoadingGameView()
}
