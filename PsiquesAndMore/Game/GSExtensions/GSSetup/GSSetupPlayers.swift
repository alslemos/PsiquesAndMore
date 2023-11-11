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
        guard let remotePlayerName = match?.players.first?.displayName else { return }

        let localPlayer = Player(displayName: GKLocalPlayer.local.displayName, controls: .upAndLeft)
        let remotePlayer = Player(displayName: remotePlayerName, controls: .downAndRight)

        self.players = [localPlayer, remotePlayer]
        players.sort { (localPlayer, remotePlayer) -> Bool in
            localPlayer.displayName < remotePlayer.displayName
        }

        self.localPlayerIndex = players.firstIndex { $0.displayName == localPlayer.displayName }
        self.remotePlayerIndex = players.firstIndex { $0.displayName == remotePlayer.displayName }

        if let index = self.localPlayerIndex, index == 0 {
            print("debug: sou o player principal")
            
            getStartDate {
                self.setGame {
                    self.startGamePublisher()
                }
            }
        }
    }
    
    func savePlayers(_ completion: @escaping () -> ()) {        
        if let index = self.localPlayerIndex, index == 0 {
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
                
                completion()
            }
        } else {
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
