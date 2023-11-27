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
            print("starting game")
            
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
        
        removeComands()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        square.removeAllActions()
        
        spawnObstaclesSubscription = nil
        
        spawnObstacleDelay = 1
        
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
