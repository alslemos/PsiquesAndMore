//
//  GSSetupPlayers.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import GameKit

extension GameScene {
    func checkPlayerIndex() {
        let localPlayer = Player(controls: .upAndLeft)
        let remotePlayer = Player(controls: .downAndRight)
        
        if isHost {
            print("debug: i am host")
            players = [localPlayer, remotePlayer]
            
            self.localPlayerIndex = 0
            self.remotePlayerIndex = 1
            
            setGame()
            getStartDate()
            startGamePublisher()
        } else {
            self.remotePlayerIndex = 0
            self.localPlayerIndex = 1
        }
    }
}
