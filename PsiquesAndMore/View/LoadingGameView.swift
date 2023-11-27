//
//  LoadingGameView.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 17/11/23.
//

import SwiftUI

struct LoadingGameView: View {
    @State var loadingText: String = "Loading"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(.fundo).ignoresSafeArea()
            
            Text(loadingText)
                .lineLimit(2)
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(Color(.clique))
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
