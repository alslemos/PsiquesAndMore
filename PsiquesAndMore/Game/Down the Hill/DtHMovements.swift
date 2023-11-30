//
//  DtHMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func moveSprite(_ movement: Movement) {
        if !self.isPaused {
            switch movement {
                case .up:
                    self.isPlayerMoving = true
                    
                    let deltaX = isRockFalling ? 0 : Int(movementImpulse)
                    let deltaY = Int(movementImpulse * 0.9)
                    
                    self.character.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
                case .down:
                    updateLoweredAsset()
                    
                    self.isPlayerMoving = true
                    
                    self.littleSpriteBody()
                case .right:
                    self.isPlayerMoving = true
                    
                    let deltaX = Int(movementImpulse)
                    let deltaY = 0
                    
                    self.character.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
                case .left:
                    self.isPlayerMoving = true
                    
                    let deltaX = -Int(movementImpulse * 0.8)
                    let deltaY = 0
                    
                    self.character.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + movementDelay) {
                self.isPlayerMoving = false
                
                self.updateAsset()
                
                self.normalSpriteBody()
            }
        }
    }
    
    func littleSpriteBody() {
        character.size = CGSize(width: 60, height: 30)
        
        let pb = SKPhysicsBody(rectangleOf: character.size, center: CGPoint(x: character.size.width / 2, y: character.frame.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = DownTheHillPhysicsCategory.characterNode
        pb.contactTestBitMask = DownTheHillPhysicsCategory.obstacleNode
        pb.collisionBitMask = DownTheHillPhysicsCategory.floorNode + DownTheHillPhysicsCategory.limitNode
        
        character.physicsBody = pb
    }
    
    func normalSpriteBody() {
        character.size = CGSize(width: 60, height: 60)
        
        let pb = SKPhysicsBody(rectangleOf: self.character.size, center: CGPoint(x: self.character.size.width / 2, y: self.character.size.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = DownTheHillPhysicsCategory.characterNode
        pb.contactTestBitMask = DownTheHillPhysicsCategory.obstacleNode
        pb.collisionBitMask = DownTheHillPhysicsCategory.floorNode + DownTheHillPhysicsCategory.limitNode
        
        self.character.physicsBody = pb
    }
}
