//
//  GSSubscriptions.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    // MARK: - Combine functions
    func createSubscriptions() {
        timerSubscription()
        createFloorPositionUpdater()
        createFloorVelocityUpdater()
        createCharacterVelocityUpdater()
        obstaclePositionUpdater()
        
        obstaclePusher()
        createDelayDecreasers()
    }
}
