//
//  DtHRandomizeControls.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func savePlayers(_ completion: @escaping () -> ()) {
        let controls = setControlsForPlayer()
        players[0].controls = controls[0]
        players[1].controls = controls[1]
        
        sendPlayerData {
            print("sending obstacles movements")
            self.sendEnemiesMovements()
            
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
