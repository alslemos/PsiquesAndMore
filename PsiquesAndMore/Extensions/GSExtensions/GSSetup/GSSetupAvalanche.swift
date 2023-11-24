//
//  GSSetupAvalanche.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 13/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupAvalanche() {
        let avalanche = SKSpriteNode(texture: SKTexture(imageNamed: "avalanche"))
        
        avalanche.size = CGSize(width: 150, height: 170)
        avalanche.anchorPoint = CGPoint(x: 0, y: 0)
        avalanche.position = CGPoint(
            x: viewFrame.minX - 40,
            y: viewFrame.midY)
        avalanche.zPosition = 10
        avalanche.zRotation = -(rotationAngle)
        avalanche.name = "avalanche"
        
        let physicsBodyAvalanche = SKPhysicsBody(rectangleOf: avalanche.size, center: CGPoint(x: avalanche.size.width / 10, y: avalanche.size.width / 2))
        
        physicsBodyAvalanche.affectedByGravity = false
        physicsBodyAvalanche.allowsRotation = false
        physicsBodyAvalanche.isDynamic = false
        
        physicsBodyAvalanche.categoryBitMask = PhysicsCategory.obstacleNode
        physicsBodyAvalanche.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyAvalanche.collisionBitMask = 16
        
        avalanche.physicsBody = physicsBodyAvalanche
        
        self.addChild(avalanche)
    }
}
