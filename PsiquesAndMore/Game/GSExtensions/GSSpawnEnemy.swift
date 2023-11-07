//
//  GSSpawnEnemy.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 07/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func setupObstacle() {
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
    }
    
    func moveObstacle(time: Double, positionOffsetX: Double, positionOffsetY: Double, completion: @escaping () -> Void) {
        let moveAction = SKAction.move(to: CGPoint(
            x: (self.view?.frame.minX ?? 0) + positionOffsetX - 100,
            y: (self.view?.frame.midY ?? 0) + positionOffsetY + ((self.view?.frame.height ?? 0.0) * 0.50)),
            duration: time)
        obstacle.run(moveAction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time + 1.0) {
            completion()
        }

    }
    
}
