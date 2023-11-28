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
            Color(.blueBlackground)
            
            VStack(spacing: 24) {
                Text("GAME OVER")
                    .font(.custom("LuckiestGuy-Regular", size: 36))
                    .foregroundColor(Color(.colorText))
                
                VStack(spacing: 8) {
                    Button {
                        NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
                    } label: {
                        Text("TRY AGAIN")
                    }
                    
                    Button {
                        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
                    } label: {
                        Text("PICK ANOTHER GAME")
                    }
                }
                .font(.custom("LuckiestGuy-Regular", size: 24))
                .foregroundColor(Color(.colorClickable))
                .padding(8)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameOverView()
}
