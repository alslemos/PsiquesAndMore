//
//  GSGKMatchDelegate.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import GameKit


extension GameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // Check if it's the game model data
        if let model = GameModel.decode(data: data) {
            gameModel = model
        }
        
        // Check if it's the controls data
        if let controls = try? JSONDecoder().decode(Movements.self, from: data) {
            guard let localIndex = localPlayerIndex else { return }
            gameModel.players[localIndex].movements = controls
            self.setupCommands()
        }
        
        if let actionString = try? JSONDecoder().decode(String.self, from: data) {
            if actionString == "pauseGame" {
                print("pause game data received")
                    
                notifyPauseGame()
            }
            
            if actionString == "continueGame" {
                print("continue game data received")
                
                isContinueOrderGiven = true
                    
                notifyContinueGame()
            }
            
            if actionString == "goToMenu" {
                print("go to menu data received")
                
                isGoToMenuOrderGiven = true

                notifyGoToMenu()
            }
            
            if actionString == "gameOver" {
                print("game over data received")
                
                notifyGameOver()
            }
            
            if actionString == "playAgain" {
                print("play again data received")
                
                isPlayAgainOrderGiven = true
                
                notifyPlayAgain()
            }
        }
        
        // Check if it's the obstacles movements data
        if let obstaclesMovements = try? JSONDecoder().decode([ObstacleMovement].self, from: data) {
            print("obstacles movements data received")
            self.obstaclesMovements = obstaclesMovements
            self.obstacleSpawner()
        }
    }
}
