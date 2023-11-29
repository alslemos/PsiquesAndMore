//
//  GSSubscriptions.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func createSubscriptions(for game: Game) {
        switch game {
            case .hill:
                createDownTheHillSubscriptions()
            case .snake:
                print("foo")
            case .squid:
                createSquidSubscriptions()
        }
    }
    
    // MARK: - Combine functions
    func createDownTheHillSubscriptions() {
        floorSpeed = 0
        
        timerSubscription()
        createFloorPositionUpdater()
        createFloorVelocityUpdater()
        createCharacterVelocityUpdater()
        obstaclePositionUpdater()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.removePositionSyncLimits()
            self.obstaclePusher()
            self.createDelayDecreasers()
        }
    }
    
    func createSquidSubscriptions() {
        // nothing here yet
    }
}
