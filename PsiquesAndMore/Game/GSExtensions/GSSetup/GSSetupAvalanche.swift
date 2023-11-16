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
        
        avalanche.size = CGSize(width: 300, height: 260)
        avalanche.anchorPoint = CGPoint(x: 0, y: 0)
        avalanche.position = CGPoint(
            x: viewFrame.minX - 64,
            y: viewFrame.midY)
        avalanche.zPosition = 10
        avalanche.zRotation = -(rotationAngle)
        avalanche.name = "avalanche"
        
        let physicsBodyAvalanche = SKPhysicsBody(rectangleOf: CGSize(
            width: avalanche.size.width - 100,
            height: avalanche.size.height - 100),
                                                 center: CGPoint(
            x: avalanche.size.width / 2 - 50,
            y: avalanche.size.height / 2 - 50))
        
        physicsBodyAvalanche.affectedByGravity = false
        physicsBodyAvalanche.allowsRotation = false
        physicsBodyAvalanche.isDynamic = false
        physicsBodyAvalanche.categoryBitMask = 4
        physicsBodyAvalanche.contactTestBitMask = 1
        physicsBodyAvalanche.collisionBitMask = 256
        
        avalanche.physicsBody = physicsBodyAvalanche
        
        self.addChild(avalanche)
    }
}
