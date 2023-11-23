//
//  GameOverView.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 01/11/23.
//

import SwiftUI

struct GameOverView: View {
    
    var fundo = Color(red: 33/255, green: 60/255, blue: 85/255)
    var clique = Color(red: 253/255, green: 169/255, blue: 101/255)
    var semclique = Color(red: 254/255, green: 211/255, blue: 166/255)
    
    var body: some View {
        ZStack {
//            Color(.red).opacity(0.7)
            fundo
            
            ZStack {
                Rectangle()
                    .foregroundColor(fundo)
                
                VStack(spacing: 24) {
                    Text("GAME OVER")
                        .font(.custom("LuckiestGuy-Regular", size: 36))
                        .foregroundColor(semclique)
                    
                    VStack {
                        
                        Button {
                            NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
                            print("DEBUG: play again")
                        } label: {
                            Text("TRY AGAIN")
                                .font(.custom("LuckiestGuy-Regular", size: 24))
                                .foregroundColor(clique)
                                .padding(4)
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
                        } label: {
                            Text("PICK ANOTHER GAME")
                                .font(.custom("LuckiestGuy-Regular", size: 24))
                                .foregroundColor(clique)
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
    GameOverView()
}
