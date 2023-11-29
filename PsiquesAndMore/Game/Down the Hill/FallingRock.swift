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
        rock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rock.position = CGPoint(x: 0, y: ((viewFrame.maxY)))
        rock.zPosition = Layers.entity
        rock.name = "rock"
        
        let physicsBodyRock = SKPhysicsBody(texture: Textures.rockPhysicsTexture, size: rock.size)
        
        physicsBodyRock.affectedByGravity = false
        physicsBodyRock.allowsRotation = true
        physicsBodyRock.isDynamic = false
        
        physicsBodyRock.categoryBitMask = DownTheHillPhysicsCategory.obstacleNode
        physicsBodyRock.contactTestBitMask = DownTheHillPhysicsCategory.characterNode
        physicsBodyRock.collisionBitMask = DownTheHillPhysicsCategory.floorNode
        
        rock.physicsBody = physicsBodyRock
        
        self.addChild(rock)
    }
    
    func moveRock() {
        self.rock.physicsBody?.affectedByGravity = true
        self.rock.physicsBody?.isDynamic = true
    }
}
