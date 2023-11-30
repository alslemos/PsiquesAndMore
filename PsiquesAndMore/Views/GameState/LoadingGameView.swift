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
            Color(.blueBlackground)
            
            Text(loadingText)
                .lineLimit(2)
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(Color(.colorClickable))
                .padding(.all)
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            if loadingText.count < 10 {
                loadingText += "."
            } else {
                loadingText = "Loading"
            }
        }
    }
}

//#Preview {
//    LoadingGameView()
//}
