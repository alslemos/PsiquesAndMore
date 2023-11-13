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
        
        print("contact felt")
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4) || (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 1) {
            players[0].numberOfLives -= 1
            players[1].numberOfLives -= 1
            print(players[0].numberOfLives)
            
            print("tocou obstaculo")
            
//            self.sendNotificationData(.gameOver) {
//                self.notify(.gameOver)
//            }
        }
    }
}
