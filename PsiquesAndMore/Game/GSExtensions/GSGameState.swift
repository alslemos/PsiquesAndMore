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
        square.removeFromParent()
        rectangle.removeFromParent()
        backgroundImage.removeFromParent()
        timerLabel.removeFromParent()
        pauseButton?.removeFromParent()
        removeComands()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        spawnObstaclesSubscription = nil
        
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
