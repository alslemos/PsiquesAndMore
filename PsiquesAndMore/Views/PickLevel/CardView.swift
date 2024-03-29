//
//  CardView.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var matchManager: MatchManager
    @Binding var showGameScene: Bool
    @Binding var showLoadingGameView: Bool
    
    let game: Game
    
    var body: some View {
        Button {
            matchManager.sendReadyState(for: game)
            
            matchManager.selectedGame = game
            
            NotificationCenter.default.post(name: .readyToPlayGameNotificationName, object: nil)
        } label: {
            VStack(spacing: 0) {
                Text(game.name)
                    .font(.custom("LuckiestGuy-Regular", size: 20))
                    .foregroundColor(Color(.colorClickable))
                    .padding(.bottom, 16)
                
                game.image
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 19)
                        .foregroundColor(Color(.colorClickable))
                    
                    Text("two players")
                        .font(.custom("LuckiestGuy-Regular", size: 12))
                        .foregroundColor(Color(.colorClickable))
                }
            }
        }
        .disabled(!game.isAvailable)
    }
}
