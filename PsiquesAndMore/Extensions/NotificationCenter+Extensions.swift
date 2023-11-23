//
//  NotificationCenter+Extensions.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 25/10/23.
//

import Foundation

extension NSNotification.Name {
    static var gameOverGameNotificationName: NSNotification.Name = NSNotification.Name("CloseGame")
    static var pauseGameNotificationName: NSNotification.Name = NSNotification.Name("PauseGame")
    static var continueGameNotificationName: NSNotification.Name = NSNotification.Name("Continue")
    static var playAgainGameNotificationName: NSNotification.Name = NSNotification.Name("PlayAgain")
    static var goToMenuGameNotificationName: NSNotification.Name = NSNotification.Name("GoToMenu")
    static var readyToPlayGameNotificationName: NSNotification.Name = NSNotification.Name("Ready")
    static var lobbyCreationNotificationName: NSNotification.Name = NSNotification.Name("LobbyCreation")
    static var loadingGameNotificationName: NSNotification.Name = NSNotification.Name("LoadingGame")
    static var backToInitialScreenNotificationName: NSNotification.Name = NSNotification.Name("BackToInitial")
    
    //Notifies authentication
    static let presentAuthenticationViewController =
    Notification.Name("presentAuthenticationViewController")
}
