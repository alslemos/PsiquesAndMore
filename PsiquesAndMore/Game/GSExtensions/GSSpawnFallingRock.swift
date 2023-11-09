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
        for _ in 0..<(self.gameDuration / Int(self.spawnRockDelay)) {
            let offsetX = Double.random(in: 5.0...20.0)
            let time = Double.random(in: 0.5...1.0)
            
            let randomObstacle = RockMovement(offsetX: offsetX, time: time)
            
            rocksMovements.append(randomObstacle)
        }
    }
    
    func sendRocksMovements(_ rocksMovements: [RockMovement]) {
        print("sending rocks movements data")
        do {
            guard let data = try? JSONEncoder().encode(rocksMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send rocks movements data failed")
        }
    }
    
    func setupRock(_ completion: @escaping () -> Void) {
        
        let rock = SKSpriteNode(color: .gray, size: CGSize(width: 60, height: 50))
        rock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let physicsBodyRock = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 50))
        physicsBodyRock.contactTestBitMask = 0x00000001
        physicsBodyRock.affectedByGravity = true
        physicsBodyRock.allowsRotation = true
        physicsBodyRock.isDynamic = true
        rock.physicsBody = physicsBodyRock
        rock.position = CGPoint(x: (viewFrame.midX), y: ((viewFrame.maxY)))
        rock.name = "rock"
        self.rock = rock
        self.addChild(rock)
        completion()
    }
    
    func moveRock(rockMovement: RockMovement, completion: @escaping () -> Void) {
        let applyImpulse = SKAction.applyImpulse(CGVector(dx: rockMovement.offsetX, dy: 0), duration: rockMovement.time)
        
        rock.run(applyImpulse)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + rockMovement.time + 10.0) {
            completion()
        }
    }
}

struct RockMovement: Codable {
    var offsetX: Double
    var offsetY: Double = 0
    var time: Double
}
