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
        
        // Check if it's the paused state data
        if let pausedState = try? JSONDecoder().decode(Bool.self, from: data) {
            print("paused state data received")
            if pausedState {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .pauseGame) {
                    print("Notifying...")
                }
            } else {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .continueGame) {
                    print("Notifying...")
                }
            }
        }
        
        // Check if it's the go to menu data
        if let goToMenu = try? JSONDecoder().decode(OrderGiven.self, from: data) {
            print("back to menu data received")
            if goToMenu == .goToMenu {
                self.isGoToMenuOrderGiven = true
                self.notifyGoToMenu()
            }
        }
        
        // Check if it's the start date data
        if let startDate = try? JSONDecoder().decode(Date.self, from: data) {
            print("start date data received")
            self.startDate = startDate
            startGamePublisher()
        }
    }
}
