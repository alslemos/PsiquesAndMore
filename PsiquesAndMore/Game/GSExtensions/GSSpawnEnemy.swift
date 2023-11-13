//
//  GSSpawnEnemy.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 07/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupEnemy(_ completion: @escaping (SKSpriteNode) -> ()) {
        let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        enemy.texture = SKTexture(imageNamed: "bird")
        enemy.anchorPoint = CGPoint(x: 0, y: 0)
        enemy.position = CGPoint(x: viewFrame.maxX, y: 0)
        enemy.zPosition = 1
        enemy.zRotation = -(rotationAngle)
        enemy.name = "enemy"
        
        let physicsBodyObstacle = SKPhysicsBody(rectangleOf: enemy.size, center: CGPoint(x: enemy.frame.width / 2, y: enemy.frame.height / 2))
        
        physicsBodyObstacle.affectedByGravity = false
        physicsBodyObstacle.allowsRotation = false
        physicsBodyObstacle.isDynamic = true
        physicsBodyObstacle.categoryBitMask = 4
        physicsBodyObstacle.contactTestBitMask = 1
        physicsBodyObstacle.collisionBitMask = 16
        
        enemy.physicsBody = physicsBodyObstacle
        
        self.addChild(enemy)
        self.obstacles.append(enemy)
        
        completion(enemy)
    }
    
    func moveEnemy(enemy: SKSpriteNode, enemyMovement: EnemyMovement) {
        let yPosition = enemyMovement.yPosition
        
        var offsetY: CGFloat = 0
        
        switch yPosition {
            case .low:
               offsetY = 0
            case .medium:
                offsetY = (square.frame.height / 2) / cos(rotationAngle)
            case .high:
                offsetY = square.frame.height / cos(rotationAngle)
        }
        
        enemy.position = CGPoint(x: enemy.position.x, y: enemy.position.y + offsetY)
        
        let moveAction = SKAction.move(to: CGPoint(
            x: 0,
            y: (verticalThresholdPoint + offsetY)),
            duration: enemyMovement.time
        )
        
        enemy.run(moveAction)
    }
}

struct EnemyMovement: Codable {
    var yPosition: YPosition
    var time: Double
}

enum YPosition: CaseIterable, Codable {
    case low
    case medium
    case high
}
