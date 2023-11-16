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
            
            getStartDate {
                self.setGame {
                    self.startGamePublisher()
                }
            }
        } else {
            self.remotePlayerIndex = 0
            self.localPlayerIndex = 1
        }
    }
    
    func savePlayers(_ completion: @escaping () -> ()) {
        let controls = setControlsForPlayer()
        players[0].controls = controls[0]
        players[1].controls = controls[1]
        
        sendPlayerData {
            print("triggering commands")
            self.setupCommands()
            
            print("sending obstacles movements")
            self.sendEnemiesMovements()
            
            print("sending rocks movements")
            self.sendRocksMovements()
            
            print("sending obstacles order")
            self.sendObstaclesOrder()
            
            completion()
        }
    }
    
    func setControlsForPlayer() -> [Controls] {
        var allControls: [Controls] = Controls.allCases
        var localPlayerControls: Controls = .upAndLeft
        var remotePlayerControls: Controls = .downAndRight
        
        guard let controls = allControls.randomElement() else { return [] }
        localPlayerControls = controls
        
        guard let index = (allControls.firstIndex { $0 == localPlayerControls }) else { return [] }
        allControls.remove(at: index)
        
        remotePlayerControls = allControls[0]
        
        print("my controls: \(localPlayerControls)")
        print("their controls: \(remotePlayerControls)")
        
        return [localPlayerControls, remotePlayerControls]
    }
}
