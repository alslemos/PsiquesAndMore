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
        }
        
        // Check if it's the movement data
        if let movement = try? JSONDecoder().decode(Movement.self, from: data) {
            switch movement {
                case .up:
                    self.moveSprite(.up)
                case .down:
                    self.moveSprite(.down)
                case .right:
                    self.moveSprite(.right)
                case .left:
                    self.moveSprite(.left)
            }
        }
        
        if let actionString = try? JSONDecoder().decode(String.self, from: data) {
            if actionString == NotificationType.pauseGame.rawValue {
                print("pause game data received")
                    
                notify(.pauseGame)
            }
            
            if actionString == NotificationType.continueGame.rawValue {
                print("continue game data received")
                
                isContinueOrderGiven = true
                    
                notify(.continueGame)
            }
            
            if actionString == NotificationType.goToMenu.rawValue {
                print("go to menu data received")
                
                isGoToMenuOrderGiven = true

                notify(.goToMenu)
            }
            
            if actionString == NotificationType.gameOver.rawValue {
                print("game over data received")
                
                notify(.gameOver)
            }
            
            if actionString == NotificationType.playAgain.rawValue {
                print("play again data received")
                
                isPlayAgainOrderGiven = true
                
                notify(.playAgain)
            }
            
            if actionString == NotificationType.loading.rawValue {
                print("loading data received")
                
                notify(.loading)
            }
            
            if actionString == "damage" {
                print("damage data received")
                
                self.lifes -= 1
            }
            
            if actionString == "instaKill" {
                print("insta kill data received")
                
                self.lifes = 0
            }
        }
        
        // Check if it's the obstacles movements data
        if let enemiesMovements = try? JSONDecoder().decode([EnemyMovement].self, from: data) {
            print("enemies movements data received")
            self.enemiesMovements = enemiesMovements
        }
        
        // Check if it's the obstacles order data
        if let obstaclesOrder = try? JSONDecoder().decode([Obstacle].self, from: data) {
            print("obstacles order data received")
            self.obstaclesOrder = obstaclesOrder
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