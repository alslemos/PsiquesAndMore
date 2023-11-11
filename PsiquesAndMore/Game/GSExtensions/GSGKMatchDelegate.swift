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
        // Check if it's the players data
        if let players = try? JSONDecoder().decode([Player].self, from: data) {
            self.players = players
            self.setupCommands()
        }
        
        // Check if it's the movement data
        if let movement = try? JSONDecoder().decode(Movement.self, from: data) {
            switch movement {
                case .up:
                    self.moveSpriteUP()
                case .down:
                    self.moveSpriteDown()
                case .right:
                    self.moveSpriteRight()
                case .left:
                    self.moveSpriteLeft()
            }
        }
        
        if let actionString = try? JSONDecoder().decode(String.self, from: data) {
            if actionString == "pauseGame" {
                print("pause game data received")
                    
                notify(.pauseGame)
            }
            
            if actionString == "continueGame" {
                print("continue game data received")
                
                isContinueOrderGiven = true
                    
                notify(.continueGame)
            }
            
            if actionString == "goToMenu" {
                print("go to menu data received")
                
                isGoToMenuOrderGiven = true

                notify(.goToMenu)
            }
            
            if actionString == "gameOver" {
                print("game over data received")
                
                notify(.gameOver)
            }
            
            if actionString == "playAgain" {
                print("play again data received")
                
                isPlayAgainOrderGiven = true
                
                notify(.playAgain)
            }
        }
        
        // Check if it's the obstacles movements data
        if let obstaclesMovements = try? JSONDecoder().decode([EnemyMovement].self, from: data) {
            print("obstacles movements data received")
            self.enemiesMovements = obstaclesMovements
        }
        
        // Check if it's the rocks movements data
        if let rocksMovements = try? JSONDecoder().decode([RockMovement].self, from: data) {
            print("rocks movements data received")
            self.rocksMovements = rocksMovements
        }
        
        // Check if it's the start date data
        if let startDate = try? JSONDecoder().decode(Int.self, from: data) {
            print("start date data received")
            self.startDate = startDate
            
            setGame {
                self.startGamePublisher()
            }
        }
    }
}
