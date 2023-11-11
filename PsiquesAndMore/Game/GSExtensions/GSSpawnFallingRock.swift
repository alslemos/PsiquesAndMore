//
//  GSSpawnFallingRock.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 08/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func createRocksArray() {
        for _ in 0..<100 {
            let offsetX = Double.random(in: 5.0...20.0)
            let time = Double.random(in: 0.5...1.0)
            
            let randomObstacle = RockMovement(offsetX: offsetX, time: time)
            
            rocksMovements.append(randomObstacle)
        }
    }
    
    func sendRocksMovements() {
        print("sending rocks movements data")
        do {
            guard let data = try? JSONEncoder().encode(rocksMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send rocks movements data failed")
        }
    }
    
    func setupRock(_ completion: @escaping (SKSpriteNode) -> Void) {
        print("inside setupRock")
        
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
        self.rocks.append(rock)
        
        completion(rock)
    }
    
    func moveRock(rock: SKSpriteNode, rockMovement: RockMovement) {
        let applyImpulse = SKAction.applyImpulse(CGVector(dx: rockMovement.offsetX, dy: 0), duration: rockMovement.time)
        
        rock.run(applyImpulse)
    }
    
    func removeRocks() {
        if rocks.count > 0 {
            if rocks[0].position.x >= viewFrame.width {
                rocks[0].removeFromParent()
                rocks.remove(at: 0)
            }
        }
    }
}

struct RockMovement: Codable {
    var offsetX: Double
    var time: Double
}
