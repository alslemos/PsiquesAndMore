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
    }
    
    func obstacleSpawner() {
        print("DEBUG: inside obstacleSpawner")
        
        let timer = Timer.publish(every: self.spawnObstacleDelay, on: .main, in: .common)
            .autoconnect()
        
        let subscription = timer
        
        var lastObstacleMovement: Int = 0
        
        subscription
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastObstacleMovement = count
                    
                    return count + 1
                } else {
                    return count
                }
            }
            .sink { count in
                print("obstacle counter: \(count)")
                
                print("last obstacle counter: \(lastObstacleMovement)")
                
                if (count < (self.gameDuration / Int(self.spawnObstacleDelay)) && count != lastObstacleMovement) {
                    let obstacleMovement = self.obstaclesMovements[count]
                    
                    self.setupObstacle {
                        self.moveObstacle(obstacleMovement: obstacleMovement) {
                            if let child = self.childNode(withName: "obstacle") as? SKSpriteNode {
                                child.removeFromParent()
                            }
                        }
                    }
                }
            }.store(in: &cancellables)
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
