//
//  GSObstacles.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 13/11/23.
//

import Foundation
import SpriteKit

enum Obstacle: CaseIterable, Codable {
    case enemy
    case rock
    case tree
}

extension GameScene {
    // MARK: - Obstacles Subscriptions
    func obstaclePositionUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        
        let subscription = publisher
        
        subscription
            .sink { _ in
                self.repositionObstacles()
            }.store(in: &cancellables)
    }
    
    func obstaclePusher() {
        var lastObstacle: Int = 0
        
        spawnObstaclesSubscription = Timer.publish(every: self.spawnObstacleDelay, on: .main, in: .common)
            .autoconnect()
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastObstacle = count
                    
                    self.currentObstacle += 1
                    
                    return count + 1
                } else {
                    return lastObstacle
                }
            }
            .sink { count in
                if count != lastObstacle {
                    let obstacle = self.obstaclesOrder[self.currentObstacle % self.obstaclesOrder.count]
                    
                    switch obstacle {
                        case .enemy:
                            self.currentEnemyMovement += 1
                            
                            let enemyMovement = self.enemiesMovements[self.currentEnemyMovement % self.enemiesMovements.count]
                            
                            self.moveObstacle(for: .enemy, enemyMovement: enemyMovement)
                            
                            self.isRockFalling = false
                        case .rock:
                            self.moveObstacle(for: .rock)
                            
                            self.isRockFalling = true
                        case .tree:
                            self.moveObstacle(for: .tree)
                            
                            self.isRockFalling = false
                    }
                }
            }
    }
    
    func createDelayDecreasers() {
        let timer = Timer.publish(every: 8, on: .main, in: .common)
            .autoconnect()
        
        let obstacleSubscription = timer
        
        obstacleSubscription
            .sink { _ in
                if !self.isPaused {
                    if self.spawnObstacleDelay > 0 {
                        self.spawnObstacleDelay -= 0.25
                        self.removeObstacleSpawner()
                    }
                }
            }.store(in: &cancellables)
    }
    
    func removeObstacleSpawner() {
        if self.spawnObstacleDelay > 0 {
            spawnObstaclesSubscription = nil
            obstaclePusher()
        }
    }
    
    // MARK: - Obstacles Actions
    func createObstaclesArray() {
        for _ in 0..<100 {
            // Creatiing enemies array
            let yPositions: [YPosition] = YPosition.allCases
            let randomYPosition = yPositions.randomElement()
            
            guard let yPosition = randomYPosition else { return }
            
            let enemyTime = Double.random(in: 1.5...2.0)
            
            let randomEnemyMovement = EnemyMovement(yPosition: yPosition, time: enemyTime)
            
            enemiesMovements.append(randomEnemyMovement)
            
            // Creating obstacles array
            let obstacleCases: [Obstacle] = Obstacle.allCases
            let randomObstacle = obstacleCases.randomElement()
            
            guard let obstacle = randomObstacle else { return }
            
            obstaclesOrder.append(obstacle)
        }
    }
    
    func repositionObstacles() {
        if enemy.position.x <= -50 {
            enemy.position = CGPoint(x: viewFrame.maxX, y: 0)
            enemy.removeAllActions()
        }
        
        if rock.position.x >= viewFrame.width {
            rock.position = CGPoint(x: 0, y: ((viewFrame.maxY)))
            rock.physicsBody?.affectedByGravity = false
            rock.physicsBody?.isDynamic = false
        }
        
        if tree.position.x <= 0 {
            tree.position = CGPoint(x: viewFrame.maxX, y: tree.size.height - 8)
            tree.removeAllActions()
        }
    }
    
    func moveObstacle(for obstacle: Obstacle, enemyMovement: EnemyMovement? = nil) {
        switch obstacle {
            case .enemy:
                guard let enemyMovement = enemyMovement else { return }
                
                moveEnemy(enemyMovement: enemyMovement)
            case .rock:
                
                moveRock()
            case .tree:
                moveTree()
        }
    }
}
