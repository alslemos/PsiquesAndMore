//
//  GSSpawnEnemy.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 07/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func createObstaclesArray(_ completion: @escaping () -> ()) {
        for _ in 0..<30 {
            let offsetY = Double.random(in: 0.0...400.0)
            let time = Double.random(in: 0.5...2.0)
            
            let randomObstacle = ObstacleMovement(offsetY: offsetY, time: time)
            
            obstaclesMovements.append(randomObstacle)
        }
        
        sendObstaclesMovements(obstaclesMovements) {
            completion()
        }
    }
    
    func sendObstaclesMovements(_ obstaclesMovements: [ObstacleMovement], _ completion: @escaping () -> ()) {
        print("sending obstacles movements data")
        do {
            guard let data = try? JSONEncoder().encode(obstaclesMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send obstacles movements data failed")
        }
    }
    
    func setupObstacle(_ completion: @escaping () -> ()) {
        let obstacle = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let physicsBodyObstacle = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        physicsBodyObstacle.contactTestBitMask = 0x00000001
        physicsBodyObstacle.affectedByGravity = false
        physicsBodyObstacle.allowsRotation = false
        physicsBodyObstacle.isDynamic = true
        obstacle.physicsBody = physicsBodyObstacle
        obstacle.position = CGPoint(x: (self.view?.frame.maxX) ?? 0 + 100, y: (self.view?.frame.midY) ?? 0)
        obstacle.name = "obstacle"
        self.obstacle = obstacle
        self.addChild(obstacle)
        completion()
    }
    
    func moveObstacle(obstacleMovement: ObstacleMovement, completion: @escaping () -> Void) {
        let moveAction = SKAction.move(to: CGPoint(
            x: (self.view?.frame.minX ?? 0) + obstacleMovement.offsetX - 100,
            y: (self.view?.frame.midY ?? 0) + obstacleMovement.offsetY + ((self.view?.frame.height ?? 0.0) * 0.50)),
                                       duration: obstacleMovement.time)
        obstacle.run(moveAction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + obstacleMovement.time + 1.0) {
            completion()
        }
    }
}

struct ObstacleMovement: Codable {
    var offsetX: Double = 0
    var offsetY: Double
    var time: Double
}
