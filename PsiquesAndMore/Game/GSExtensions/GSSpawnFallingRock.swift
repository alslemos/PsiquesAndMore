//
//  GSSpawnFallingRock.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 08/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupRock() {
        rock.texture = SKTexture(imageNamed: "rock")
        rock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rock.position = CGPoint(x: 0, y: ((viewFrame.maxY)))
        rock.name = "rock"
        
        let physicsBodyRock = SKPhysicsBody(texture: rock.texture!, size: rock.size)
        
        physicsBodyRock.affectedByGravity = false
        physicsBodyRock.allowsRotation = true
        physicsBodyRock.isDynamic = false
        
        physicsBodyRock.categoryBitMask = PhysicsCategory.obstacleNode
        physicsBodyRock.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyRock.collisionBitMask = PhysicsCategory.floorNode
        
        rock.physicsBody = physicsBodyRock
        
        self.addChild(rock)
    }
    
    func moveRock() {
        self.rock.physicsBody?.affectedByGravity = true
        self.rock.physicsBody?.isDynamic = true
    }
}
