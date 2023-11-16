//
//  GSMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func moveSprite(_ movement: Movement) {
        switch movement {
            case .up:
                self.isPlayerMoving = true
                
                self.square.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
            case .down:
                self.isPlayerMoving = true
                
                self.littleSpriteBody()
            case .right:
                self.isPlayerMoving = true
                
                self.square.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
            case .left:
                self.isPlayerMoving = true
                
                self.square.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isPlayerMoving = false
            
            self.normalSpriteBody()
        }
        
    }
    
    func littleSpriteBody() {
        square.size = CGSize(width: 30, height: 15)
        
        let pb = SKPhysicsBody(rectangleOf: square.size, center: CGPoint(x: square.size.width / 2, y: square.frame.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true

        pb.categoryBitMask = PhysicsCategory.characterNode
        pb.contactTestBitMask = PhysicsCategory.obstacleNode
        pb.collisionBitMask = PhysicsCategory.floorNode + PhysicsCategory.limitNode
        
        square.physicsBody = pb
    }
    
    func normalSpriteBody() {
        square.size = CGSize(width: 30, height: 30)
        
        let pb = SKPhysicsBody(rectangleOf: self.square.size, center: CGPoint(x: self.square.size.width / 2, y: self.square.size.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true

        pb.categoryBitMask = PhysicsCategory.characterNode
        pb.contactTestBitMask = PhysicsCategory.obstacleNode
        pb.collisionBitMask = PhysicsCategory.floorNode + PhysicsCategory.limitNode
        
        self.square.physicsBody = pb
    }
}

enum Movement: Codable {
    case up
    case down
    case left
    case right
}
