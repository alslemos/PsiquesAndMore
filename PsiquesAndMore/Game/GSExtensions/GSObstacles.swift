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
    func obstacleRemover() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        
        let subscription = publisher
        
        subscription
            .sink { _ in
                self.removeObstacles()
            }.store(in: &cancellables)
    }
    
    func obstacleSpawner() {
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
                            
                            self.setupObstacle(for: .enemy) { enemy in
                                self.moveObstacle(for: .enemy, with: enemy, enemyMovement: enemyMovement)
                            }
                        case .rock:
                            self.currentRockMovement += 1
                            
                            let rockMovement = self.rocksMovements[self.currentRockMovement % self.rocksMovements.count]
                            
                            self.setupObstacle(for: .rock) { rock in
                                self.moveObstacle(for: .rock, with: rock, rockMovement: rockMovement)
                            }
                        case .tree:
                            self.setupObstacle(for: .tree) { tree in
                                self.moveObstacle(for: .tree, with: tree)
                            }
                    }
                }
            }
    }
    
    func createDelayDecreasers() {
        let timer = Timer.publish(every: 4, on: .main, in: .common)
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
            obstacleSpawner()
        }
    }
    
    // MARK: - Obstacles Actions
    func createObstaclesArray() {
        for _ in 0..<100 {
            // Creatiing enemies array
            let yPositions: [YPosition] = YPosition.allCases
            let randomYPosition = yPositions.randomElement()
            
            guard let yPosition = randomYPosition else { return }
            
            let enemyTime = Double.random(in: 0.5...2.0)
            
            let randomEnemyMovement = EnemyMovement(yPosition: yPosition, time: enemyTime)
            
            enemiesMovements.append(randomEnemyMovement)
            
            // Creating rocks array
            let offsetX = Double.random(in: 5.0...20.0)
            let rockTime = Double.random(in: 0.5...1.0)
            
            let randomRockMovement = RockMovement(offsetX: offsetX, time: rockTime)
            
            rocksMovements.append(randomRockMovement)
            
            // Creating obstacles array
            let obstacleCases: [Obstacle] = Obstacle.allCases
            let randomObstacle = obstacleCases.randomElement()
            
            guard let obstacle = randomObstacle else { return }
            
            obstaclesOrder.append(obstacle)
        }
    }
    
    func setupObstacle(for obstacle: Obstacle,_ completion: @escaping (SKSpriteNode) -> ()) {
        switch obstacle {
            case .enemy:
                setupEnemy { enemy in
                    completion(enemy)
                }
            case .rock:
                setupRock { rock in
                    completion(rock)
                }
            case .tree:
                setUpTree { tree in
                    completion(tree)
                }
        }
    }
    
    func removeObstacles() {
        if obstacles.count > 0 {
            if obstacles[0].name == "enemy" {
                if obstacles[0].position.x <= -50 {
                    print("removing enemy")
                    obstacles[0].removeFromParent()
                    obstacles.remove(at: 0)
                }
            } else if obstacles[0].name == "rock" {
                if obstacles[0].position.x >= viewFrame.width {
                    print("removing rock")
                    obstacles[0].removeFromParent()
                    obstacles.remove(at: 0)
                }
            } else if obstacles[0].name == "tree" {
                if obstacles[0].position.x <= 0 {
                    print("removing tree")
                    obstacles[0].removeFromParent()
                    obstacles.remove(at: 0)
                }
            }
        }
    }
    
    func moveObstacle(for obstacle: Obstacle, with node: SKSpriteNode, enemyMovement: EnemyMovement? = nil, rockMovement: RockMovement? = nil) {
        switch obstacle {
            case .enemy:
                guard let enemyMovement = enemyMovement else { return }
                
                moveEnemy(enemy: node, enemyMovement: enemyMovement)
            case .rock:
                guard let rockMovement = rockMovement else { return }
                
                moveRock(rock: node, rockMovement: rockMovement)
            case .tree:
                moveTree(tree: node)
        }
    }
}
