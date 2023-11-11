//
//  GSSpawnEnemy.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 07/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func createEnemiesArray() {
        print("debug: inside create obstacle array")
        
        for _ in 0..<100 {
            let yPositions: [YPosition] = YPosition.allCases
            let randomYPosition = yPositions.randomElement()
            
            guard let yPosition = randomYPosition else { return }
            
            let time = Double.random(in: 0.5...2.0)
            
            let randomEnemyMovement = EnemyMovement(yPosition: yPosition, time: time)
            
            enemiesMovements.append(randomEnemyMovement)
        }
    }
    
    func sendEnemiesMovements() {
        print("sending enemies movements data")
        do {
            guard let data = try? JSONEncoder().encode(enemiesMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send enemies movements data failed")
        }
    }
    
    func setupEnemy(_ completion: @escaping (SKSpriteNode) -> ()) {
        let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        enemy.texture = SKTexture(imageNamed: "bird")
        enemy.anchorPoint = CGPoint(x: 0, y: 0)
        enemy.position = CGPoint(x: viewFrame.maxX, y: 0)
        enemy.zPosition = 1
        enemy.zRotation = -(rotationAngle)
        enemy.name = "obstacle"
        
        let physicsBodyObstacle = SKPhysicsBody(rectangleOf: enemy.size, center: CGPoint(x: enemy.frame.width / 2, y: enemy.frame.height / 2))
        
        physicsBodyObstacle.affectedByGravity = false
        physicsBodyObstacle.allowsRotation = false
        physicsBodyObstacle.isDynamic = true
        physicsBodyObstacle.categoryBitMask = 4
        physicsBodyObstacle.contactTestBitMask = 1
        physicsBodyObstacle.collisionBitMask = 16
        
        enemy.physicsBody = physicsBodyObstacle
        
        self.addChild(enemy)
        self.enemies.append(enemy)
        
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
    
    func removeObstacles() {
        if enemies.count > 0 {
            if enemies[0].position.x <= 0 {
                print("removing obstacle")
                enemies[0].removeFromParent()
                enemies.remove(at: 0)
            }
        }
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
