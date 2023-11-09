//
//  GSNotifications.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func notifyPauseGame() {
        NotificationCenter.default.post(name: .pauseGameNotificationName, object: nil)
        print("DEBUG: pause game")
    }
    
    func notifyContinueGame() {
        NotificationCenter.default.post(name: .continueGameNotificationName, object: nil)
        print("DEBUG: continue game")
    }
    
    func notifyGoToMenu() {
        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
        print("DEBUG: go to menu")
    }
    
    func notifyGameOver() {
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
        print("DEBUG: game over")
    }
    
    func notifyPlayAgain() {
        NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
        print("DEBUG: play again")
    }
}
