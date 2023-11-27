//
//  GameOverView.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 01/11/23.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        ZStack {
            Color(.fundo)
            
            VStack(spacing: 24) {
                Text("GAME OVER")
                    .font(.custom("LuckiestGuy-Regular", size: 36))
                    .foregroundColor(Color(.semclique))
                
                VStack {
                    
                    Button {
                        NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
                        print("DEBUG: play again")
                    } label: {
                        Text("TRY AGAIN")
                            .font(.custom("LuckiestGuy-Regular", size: 24))
                            .foregroundColor(Color(.clique))
                            .padding(4)
                    }
                    
                    Button {
                        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
                    } label: {
                        Text("PICK ANOTHER GAME")
                            .font(.custom("LuckiestGuy-Regular", size: 24))
                            .foregroundColor(Color(.clique))
                            .padding(4)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameOverView()
}
