//
//  GSContactDelegate.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 09/11/23.
//

import Foundation
import SpriteKit

struct DownTheHillPhysicsCategory {
    static let characterNode: UInt32 = 0x1 << 0
    static let floorNode: UInt32 = 0x1 << 1
    static let obstacleNode: UInt32 = 0x1 << 2
    static let avalancheNode: UInt32 = 0x1 << 3
    static let limitNode: UInt32 = 0x1 << 4
}

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if isHost {
            // check for player touching obstacles
            if !isPlayerInvincible {
                if contactMask == DownTheHillPhysicsCategory.characterNode | DownTheHillPhysicsCategory.obstacleNode {
                    print("DEBUG: touched obstacle")
                    
                    self.lifes -= 1
                    self.isPlayerInvincible = true
                }
            }
        }
        
        // check for player touching avalanche
        if contactMask == DownTheHillPhysicsCategory.characterNode | DownTheHillPhysicsCategory.avalancheNode {
            print("DEBUG: touched avalanche")
            
            self.lifes = 0
        }
        
        // check for player touching ground
        if contactMask == DownTheHillPhysicsCategory.characterNode | DownTheHillPhysicsCategory.floorNode {
            print("DEBUG: player is touching ground")
            
            self.isPlayerTouchingFloor = true
            self.snowParticle.particleBirthRate = 40
        }
    }
    
    // check if player stopped touching ground
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == DownTheHillPhysicsCategory.characterNode | DownTheHillPhysicsCategory.floorNode {
            print("DEBUG: player is not touching ground")
            
            self.isPlayerTouchingFloor = false
            self.snowParticle.particleBirthRate = 0
        }
    }
}
