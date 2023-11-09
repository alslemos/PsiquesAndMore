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
            Color(.black).opacity(0.7)
                .ignoresSafeArea()
            
            ZStack {
                Rectangle()
                    .frame(maxWidth: 400, maxHeight: 300)
                    .foregroundColor(.white)
                
                VStack(spacing: 64) {
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    HStack {
                        
                        Button {
                            NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
                            print("DEBUG: play again")
                        } label: {
                            Text("TRY AGAIN")
                                .foregroundColor(.white)
                                .padding()
                                .background(.black)
                                .cornerRadius(8)
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
                        } label: {
                            Text("MENU")
                                .foregroundColor(.white)
                                .padding()
                                .background(.black)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .cornerRadius(4)        }
    }
}

#Preview {
    GameOverView()
}
