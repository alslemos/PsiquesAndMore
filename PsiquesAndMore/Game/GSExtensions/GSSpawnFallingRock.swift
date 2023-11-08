//
//  GSSpawnFallingRock.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 08/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func createRocksArray(_ completion: @escaping () -> Void) {
        for _ in 0..<30 {
            let offsetY = Double.random(in: 0.0...400.0)
            let time = Double.random(in: 0.5...2.0)
            
            let randomObstacle = RockMovement(offsetX: 15, time: 0.5)
            
            rocksMovements.append(randomObstacle)
        }
        
        sendRocksMovements(rocksMovements) {
            completion()
        }
    }
    
    func sendRocksMovements(_ rocksMovements: [RockMovement], _ completion: @escaping () -> Void) {
        print("sending rocks movements data")
        do {
            guard let data = try? JSONEncoder().encode(rocksMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send rocks movements data failed")
        }
    }
    
    func setupRock(_ obstaclesMovements: [ObstacleMovement], _ completion: @escaping () -> Void) {
        
        let rock = SKSpriteNode(color: .gray, size: CGSize(width: 60, height: 50))
        rock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let physicsBodyRock = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 50))
        physicsBodyRock.contactTestBitMask = 0x00000001
        physicsBodyRock.affectedByGravity = true
        physicsBodyRock.allowsRotation = true
        physicsBodyRock.isDynamic = true
        rock.physicsBody = physicsBodyRock
        rock.position = CGPoint(x: (self.view?.frame.midX) ?? 0, y: (self.view?.frame.maxY) ?? 0 + 100)
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
