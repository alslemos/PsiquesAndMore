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
        avalanche.size = CGSize(width: 160, height: 180)
        avalanche.anchorPoint = CGPoint(x: 0, y: 0)
        avalanche.position = CGPoint(
            x: viewFrame.minX - 40,
            y: viewFrame.midY)
        avalanche.zPosition = Layers.avalanche
        avalanche.zRotation = -(rotationAngle)
        avalanche.name = "avalanche"
        
        let physicsBodyAvalanche = SKPhysicsBody(rectangleOf: avalanche.size, center: CGPoint(x: avalanche.size.width / 10, y: avalanche.size.width / 2))
        
        physicsBodyAvalanche.affectedByGravity = false
        physicsBodyAvalanche.allowsRotation = false
        physicsBodyAvalanche.isDynamic = false
        
        physicsBodyAvalanche.categoryBitMask = PhysicsCategory.avalancheNode
        physicsBodyAvalanche.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyAvalanche.collisionBitMask = 16
        
        avalanche.physicsBody = physicsBodyAvalanche
        
        self.addChild(avalanche)
        
        animateAvalanche()
    }
    
    func animateAvalanche() {
        var textures: [SKTexture] = []
        
        for i in 0..<2 {
            let texture = SKTexture(imageNamed: "avalanche\(i)")
            textures.append(texture)
        }
        
        avalanche.run(.repeatForever(.animate(with: textures, timePerFrame: 0.1)))
    }
}
