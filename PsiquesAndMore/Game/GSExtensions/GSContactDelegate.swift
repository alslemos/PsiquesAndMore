//
//  GSContactDelegate.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // check for player touching obstacles
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4) || (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 1) {
            players[0].numberOfLives -= 1
            players[1].numberOfLives -= 1
            print(players[0].numberOfLives)
//            self.sendNotificationData(.gameOver) {
//                self.notify(.gameOver)
//            }
        }
        
        // check for player touching ground
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 8) || (bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 1) {
            
            print("DEBUG: player is touching ground")
            self.isPlayerTouchingFloor = true
            self.snowParticle.particleBirthRate = 40
            
        }
    }
    
    // check if player stopped touching ground
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 8) || (bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 1) {
            
            print("DEBUG: player is not touching ground")
            self.isPlayerTouchingFloor = false
            self.snowParticle.particleBirthRate = 0
            
        }
    }
}
