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
        let enemy = SKSpriteNode(texture: SKTexture(imageNamed: "bird"), size: CGSize(width: 50, height: 50))
        enemy.anchorPoint = CGPoint(x: 0, y: 0)
        enemy.position = CGPoint(x: viewFrame.maxX, y: 0)
        enemy.zPosition = 1
        enemy.zRotation = -(rotationAngle)
        enemy.name = "enemy"
        
        let physicsBodyEnemy = SKPhysicsBody(rectangleOf: enemy.size, center: CGPoint(x: enemy.size.width / 2, y: enemy.size.height / 2))
        
        physicsBodyEnemy.affectedByGravity = false
        physicsBodyEnemy.allowsRotation = false
        physicsBodyEnemy.isDynamic = true
        
        physicsBodyEnemy.categoryBitMask = PhysicsCategory.obstacleNode
        physicsBodyEnemy.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyEnemy.collisionBitMask = PhysicsCategory.floorNode
        
        enemy.physicsBody = physicsBodyEnemy
        
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
            x: -100,
            y: (verticalThresholdPoint + offsetY + (100 * tan(rotationAngle)))),
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
