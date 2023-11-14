//
//  PlayView.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 13/11/23.
//

import SwiftUI
import GameKit

struct PlayView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            if matchManager.isGamePresented {
                FirstView(matchManager: _matchManager)
            } else {
                Button {
                    matchManager.startMatchmaking()
                } label: {
                    Text("Create lobby")
                }
                .onAppear {
                    if matchManager.authenticationState != .authenticated {
                        matchManager.authenticatePlayer()
                    }
                }
                .onDisappear {
                    GKAccessPoint.shared.isActive = false
//                        matchManager.isGamePresented = false
                }
            }
        }
    }
}

//#Preview {
//    PlayView()
//}
