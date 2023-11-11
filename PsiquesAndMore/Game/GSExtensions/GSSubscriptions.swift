//
//  GSSubscriptions.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    // MARK: - Combine functions
    func createSubscriptions() {
        timerSubscription()
        createBackgroundPositionUpdater()
        createBackgroundVelocityUpdater()
        createCharacterVelocityUpdater()
        obstacleRemover()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.enemySpawner()
            self.rockSpawner()
            self.createDelayDecreasers()
        }
    }
    
    // MARK: - Obstacles Subscriptions
    func obstacleRemover() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        
        let subscription = publisher
        
        subscription
            .sink { _ in
                self.removeObstacles()
                self.removeRocks()
            }.store(in: &cancellables)
    }
    
    func enemySpawner() {
        var lastEnemyMovement: Int = 0
        
        spawnEnemiesSubscription = Timer.publish(every: self.spawnEnemyDelay, on: .main, in: .common)
            .autoconnect()
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastEnemyMovement = count
                    
                    self.currentEnemyMovement += 1
                    
                    return count + 1
                } else {
                    return lastEnemyMovement
                }
            }
            .sink { count in
                print("enemy counter: \(count)")
                
                print("last enemy counter: \(lastEnemyMovement)")
                
                print("enemy spawn delay: \(self.spawnEnemyDelay)")
                
                if count != lastEnemyMovement {
                    let enemyMovement = self.enemiesMovements[self.currentEnemyMovement % self.enemiesMovements.count]
                    
                    self.setupEnemy { enemy in
                        print("setting obstacle")
                        self.moveEnemy(enemy: enemy, enemyMovement: enemyMovement)
                    }
                }
            }
    }
    
    func rockSpawner() {
        print("DEBUG: inside rockSpawner")
        var lastRockMovement: Int = 0
        
        spawnRocksSubscription = Timer.publish(every: self.spawnRockDelay, on: .main, in: .common)
            .autoconnect()
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastRockMovement = count
                    
                    self.currentRockMovement += 1
                    
                    return count + 1
                } else {
                    return lastRockMovement
                }
            }
            .sink { count in
                print("rock counter: \(count)")
                
                print("last rock counter: \(lastRockMovement)")
                
                print("rock spawn delay: \(self.spawnRockDelay)")
                
                if count != lastRockMovement {
                    let rockMovement = self.rocksMovements[self.currentRockMovement % self.rocksMovements.count]
                    
                    self.setupRock { rock in
                        print("setting rock")
                        self.moveRock(rock: rock, rockMovement: rockMovement)
                    }
                }
            }
    }
    
    func createDelayDecreasers() {
        let timer = Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
        
        // enemy delay decreaser creation
        let enemySubscription = timer
        
        enemySubscription
            .sink { _ in
                if !self.isPaused {
                    if self.spawnEnemyDelay > 0 {
                        self.spawnEnemyDelay -= 0.25
                        self.removeObstacleSpawner(for: .enemy)
                    }
                }
            }.store(in: &cancellables)
        
        // rock delay decreaser creation
        let rockSubscription = timer
        
        rockSubscription
            .sink { _ in
                if !self.isPaused {
                    if self.spawnRockDelay > 0 {
                        self.spawnRockDelay -= 0.25
                        self.removeObstacleSpawner(for: .rock)
                    }
                }
            }.store(in: &cancellables)
    }
    
    func removeObstacleSpawner(for obstacle: Obstacle) {
        if obstacle == .enemy {
            if self.spawnEnemyDelay > 0 {
                spawnEnemiesSubscription = nil
                enemySpawner()
            }
        }
        
        if obstacle == .rock {
            if self.spawnRockDelay > 0 {
                spawnRocksSubscription = nil
                rockSpawner()
            }
        }
    }
    
    // MARK: - Background Subscription
    func createBackgroundPositionUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= -(self.viewFrame.width) {
                    self.rectangle.position = CGPoint(x: 0, y: self.verticalThresholdPoint)
                }
            }.store(in: &cancellables)
    }
    
    private func createBackgroundVelocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
    
    func createCharacterVelocityUpdater() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                if self.isPaused {
                    return count
                } else {
                    return count + 1
                }
            }
            .sink { count in
                if !self.isPaused {
                    self.characterVelocity += 1
                    
                    let applyImpulse = SKAction.applyImpulse(CGVector(dx: -(self.characterVelocity), dy: 0), duration: 1)
                    self.square.run(applyImpulse)
                }
            }.store(in: &cancellables)
    }
}

enum Obstacle {
    case enemy
    case rock
}
