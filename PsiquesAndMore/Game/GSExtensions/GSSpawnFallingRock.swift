//
//  GSSpawnFallingRock.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 08/11/23.
//

import Foundation
import SpriteKit

extension GameScene {    
    func setupRock(_ completion: @escaping (SKSpriteNode) -> Void) {
        let rock = SKSpriteNode(color: .gray, size: CGSize(width: 40, height: 30))
        rock.texture = SKTexture(imageNamed: "rock")
        rock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rock.position = CGPoint(x: 0, y: ((viewFrame.maxY)))
        rock.name = "rock"
        
        let physicsBodyRock = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 30))
        physicsBodyRock.affectedByGravity = true
        physicsBodyRock.allowsRotation = true
        physicsBodyRock.isDynamic = true
        physicsBodyRock.categoryBitMask = 4
        physicsBodyRock.contactTestBitMask = 1
        physicsBodyRock.collisionBitMask = 16
        
        rock.physicsBody = physicsBodyRock
        
        self.addChild(rock)
        self.obstacles.append(rock)
        
        completion(rock)
    }
    
    func moveRock(rock: SKSpriteNode, rockMovement: RockMovement) {
        let applyImpulse = SKAction.applyImpulse(CGVector(dx: rockMovement.offsetX, dy: 0), duration: rockMovement.time)
        
        rock.run(applyImpulse)
    }
}

struct RockMovement: Codable {
    var offsetX: Double
    var time: Double
}
