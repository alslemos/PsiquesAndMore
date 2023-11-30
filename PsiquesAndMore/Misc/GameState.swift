//
//  GameState.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

enum GameState: String {
    case pauseGame = "pauseGame"
    case continueGame = "continueGame"
    case goToMenu = "goToMenu"
    case gameOver = "gameOver"
    case playAgain = "playAgain"
    case loading = "loading"
    case yourTurn = "yourTurn"
    
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
            case .yourTurn:
                return .yourTurnNotificationName
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
            case .yourTurn:
                return "send your turn data failed"
        }
    }
}
