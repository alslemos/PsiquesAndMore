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
        createBackgroundPositionUpdater()
        createBackgroundVelocityUpdater()
        createCharacterVelocityUpdater()
        obstacleRemover()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.obstacleSpawner()
            self.createDelayDecreasers()
        }
    }
}
