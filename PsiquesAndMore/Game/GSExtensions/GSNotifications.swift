//
//  GSNotifications.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func notify(_ notification: NotificationType) {
        NotificationCenter.default.post(name: notification.name, object: nil)
    }
}

enum NotificationType {
    case pauseGame
    case continueGame
    case goToMenu
    case gameOver
    case playAgain
    
    var name: NSNotification.Name {
        switch self {
            case .pauseGame:
                return .pauseGameNotificationName
            case .continueGame:
                return .continueGameNotificationName
            case .goToMenu:
                return .goToMenuGameNotificationName
            case .gameOver:
                return .restartGameNotificationName
            case .playAgain:
                return .playAgainGameNotificationName
        }
    }
}
