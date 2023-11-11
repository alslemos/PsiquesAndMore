//
//  GSGameState.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func startGame() {
        if didGameStart {
            print("DEBUG: \(self.enemiesMovements)")
            print("DEBUG: \(self.rocksMovements)")

            // deallocate start game subscription
            self.startGameSubscription = nil

            // continue game
            self.isPaused = false

            self.backgroundSpeed = 0
            self.createSubscriptions()
        } else {
            self.isPaused = true

            checkPlayerIndex()
        }
    }
    
    func gameOver(_ completion: @escaping () -> ()) {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        scene.removeAllChildren()
//        square.removeFromParent()
//        rectangle.removeFromParent()
//        backgroundImage.removeFromParent()
//        timerLabel.removeFromParent()
//        pauseButton?.removeFromParent()
//        rock.removeFromParent()
//        obstacle.removeFromParent()
        removeComands()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        spawnEnemiesSubscription = nil
        spawnRocksSubscription = nil
        
        spawnRockDelay = 2
        spawnEnemyDelay = 2
        
        characterVelocity = 10
        
        completion()
    }
    
    func restartGame() {
        self.gameOver {
            self.setGame {
                self.backgroundSpeed = 0
                self.createSubscriptions()
            }
        }
    }
}
