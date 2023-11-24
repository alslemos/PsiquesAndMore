//
//  PauseGameView.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 01/11/23.
//

import SwiftUI

struct PauseGameView: View {
    var body: some View {
        ZStack {
            Color(.black).opacity(0.7)
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color(.fundo))
                
                VStack(spacing: 24) {
                    Text("PAUSED GAME")
                        .font(.custom("LuckiestGuy-Regular", size: 36))
                        .foregroundColor(Color(.semclique))
                    
                    VStack {
                        
                        Button {
                            NotificationCenter.default.post(name: .continueGameNotificationName, object: nil)
                            print("DEBUG: continue game")
                        } label: {
                            Text("CONTINUE")
                                .font(.custom("LuckiestGuy-Regular", size: 24))
                                .foregroundColor(Color(.clique))
                                .padding(4)
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
                        } label: {
                            Text("RESTART")
                                .font(.custom("LuckiestGuy-Regular", size: 24))
                                .foregroundColor(Color(.clique))
                                .padding(4)
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
                        } label: {
                            Text("QUIT")
                                .font(.custom("LuckiestGuy-Regular", size: 24))
                                .foregroundColor(Color(.clique))
                                .padding(4)
                        }
                    }
                }
            }
            .frame(maxWidth: 360, maxHeight: 245)
            .cornerRadius(8)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PauseGameView()
}
