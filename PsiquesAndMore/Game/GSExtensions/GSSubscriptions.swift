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
        backgroundPositionUpdater()
        velocityUpdater()
        obstacleSpawner()
        rockSpawner()
        foo()
        foo1()
    }
    
    func obstacleSpawner() {
        var lastObstacleMovement: Int = 0
        
        spawnObstaclesSubscription = Timer.publish(every: self.spawnObstacleDelay, on: .main, in: .common)
            .autoconnect()
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastObstacleMovement = count
                    
                    self.currentObstacleMovement += 1
                    
                    return count + 1
                } else {
                    return lastObstacleMovement
                }
            }
            .sink { count in
                print("obstacle counter: \(count)")
                
                print("last obstacle counter: \(lastObstacleMovement)")
                
                print("obstacle spawn delay: \(self.spawnObstacleDelay)")
                
                if count != lastObstacleMovement {
                    let obstacleMovement = self.obstaclesMovements[self.currentObstacleMovement % self.obstaclesMovements.count]
                    
                    self.setupObstacle {
                        print("setting obstacle")
                        self.moveObstacle(obstacleMovement: obstacleMovement) {
                            if let child = self.childNode(withName: "obstacle") as? SKSpriteNode {
                                child.removeFromParent()
                            }
                        }
                    }
                }
            }
    }
    
    func foo() {
        let timer = Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
        
        let subscription = timer
        
        subscription
            .sink { _ in
                if !self.isPaused {
                    if self.spawnObstacleDelay > 0 {
                        self.spawnObstacleDelay -= 0.25
                        self.fred()
                    }
                }
            }.store(in: &cancellables)
    }
    
    func fred() {
        if self.spawnObstacleDelay > 0 {
            spawnObstaclesSubscription = nil
            obstacleSpawner()
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
                    
                    self.setupRock {
                        print("setting rock")
                        self.moveRock(rockMovement: rockMovement) {
                            if let child = self.childNode(withName: "rock") as? SKSpriteNode {
                                child.removeFromParent()
                            }
                        }
                    }
                }
            }
    }
    
    func foo1() {
        let timer = Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
        
        let subscription = timer
        
        subscription
            .sink { _ in
                if !self.isPaused {
                    if self.spawnRockDelay > 0 {
                        self.spawnRockDelay -= 0.25
                        self.fred1()
                    }
                }
            }.store(in: &cancellables)
    }
    
    func fred1() {
        if self.spawnRockDelay > 0 {
            spawnRocksSubscription = nil
            rockSpawner()
        }
    }
    
    private func backgroundPositionUpdater() {
        guard let view = self.view else { return }
        
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= -(view.frame.width) {
                    self.rectangle.position = CGPoint(x: 0, y: self.verticalThresholdPoint)
                }
            }.store(in: &cancellables)
    }
    
    private func velocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
}
