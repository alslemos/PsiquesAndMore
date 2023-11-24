//
//  CardView.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import SwiftUI

enum Card: CaseIterable {
    case hill
    case snake
    case goat
    
    var name: String {
        switch self {
            case .hill:
                return "down the hill"
            case .snake:
                return "snake survival"
            case .goat:
                return "goat climber"
        }
    }
    
    var image: Image {
        switch self {
            case .hill:
                return Image(.grupoMona)
            case .snake:
                return Image(.gamePlaceholder)
            case .goat:
                return Image(.gamePlaceholder)
        }
    }
    
    var isAvailable: Bool {
        switch self {
            case .hill:
                return true
            case .snake:
                return false
            case .goat:
                return false
        }
    }
}

struct CardView: View {
    @ObservedObject var matchManager: MatchManager
    @Binding var showGameScene: Bool
    @Binding var showLoadingGameView: Bool
    
    let game: Card
    
    var body: some View {
        Button {
            matchManager.sendReadyState {
                self.showGameScene = true
                self.showLoadingGameView = true
            }
        } label: {
            VStack(spacing: 0) {
                Text(game.name)
                    .font(.custom("LuckiestGuy-Regular", size: 20))
                    .foregroundColor(Color(.clique))
                
                game.image
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 19)
                        .foregroundColor(Color(.clique))
                    #warning("frame and width are not responsive for other devices")
                    
                    Text("two players")
                        .font(.custom("LuckiestGuy-Regular", size: 12))
                        .foregroundColor(Color(.clique))
                }
            }
        }
        .disabled(!game.isAvailable)
    }
}
