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
    case loading
    
    var name: NSNotification.Name {
        switch self {
            case .pauseGame:
                return .pauseGameNotificationName
            case .continueGame:
                return .continueGameNotificationName
            case .goToMenu:
                return .goToMenuGameNotificationName
            case .gameOver:
                return .gameOverGameNotificationName
            case .playAgain:
                return .playAgainGameNotificationName
            case .loading:
                return .loadingGameNotificationName
        }
    }
    
    var data: String {
        switch self {
            case .pauseGame:
                return "pauseGame"
            case .continueGame:
                return "continueGame"
            case .goToMenu:
                return "goToMenu"
            case .gameOver:
                return "gameOver"
            case .playAgain:
                return "playAgain"
            case .loading:
                return "loading"
        }
    }
    
    var dataError: String {
        switch self {
            case .pauseGame:
                return "send pause game data failed"
            case .continueGame:
                return "send continue game data failed"
            case .goToMenu:
                return "send back to menu data failed"
            case .gameOver:
                return "send game over data failed"
            case .playAgain:
                return "send play again data failed"
            case .loading:
                return "send loading data failed"
        }
    }
}
