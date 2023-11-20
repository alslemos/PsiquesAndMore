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
    
    var body: some View {
        Button {
            matchManager.sendReadyState {
                self.showGameScene = true
                self.showLoadingGameView = true
            }
        } label: {
            Image("grupoMona")
                .padding()
        }
    }
}
