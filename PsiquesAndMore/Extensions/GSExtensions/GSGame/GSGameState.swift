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
    
    func clean() {
        print("cleaning scene")
        
        self.removeAllActions()
        self.removeAllChildren()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        spawnObstaclesSubscription?.cancel()
        
        virtualController?.disconnect()
        
        sendResults()
    }
}
