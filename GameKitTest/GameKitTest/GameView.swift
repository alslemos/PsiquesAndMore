//
//  GameView.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import SwiftUI
import GameKit

struct GameView: View {
    @ObservedObject var matchManager: MatchManager
    
    var match: GKMatch?
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .onAppear {
            match?.delegate = matchManager
            print("showing game view...")
        }
    }
}

#Preview {
    GameView(matchManager: MatchManager())
}
