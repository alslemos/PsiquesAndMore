//
//  GSObstacles.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 13/11/23.
//

import Foundation
import SpriteKit

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
                    
                    if obstacle == .enemy {
                        self.currentEnemyMovement += 1
                        
                        let enemyMovement = self.enemiesMovements[self.currentEnemyMovement % self.enemiesMovements.count]
                        
                        self.moveObstacle(for: obstacle, enemyMovement: enemyMovement)
                        
                        self.isRockFalling = false
                    } else {
                        if obstacle == .rock {
                            self.isRockFalling = true
                        } else {
                            self.isRockFalling = false
                        }
                        
                        self.moveObstacle(for: obstacle)
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
