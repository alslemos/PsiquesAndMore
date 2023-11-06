//
//  NotificationCenter+Extensions.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 25/10/23.
//

import Foundation

extension NSNotification.Name {
    static var restartGameNotificationName: NSNotification.Name = NSNotification.Name("CloseGame")
    
    static var pauseGameNotificationName: NSNotification.Name = NSNotification.Name("PauseGame")
    static var continueGameNotificationName: NSNotification.Name = NSNotification.Name("Continue")
    static var playAgainGameNotificationName: NSNotification.Name = NSNotification.Name("PlayAgain")
    static var goToMenuGameNotificationName: NSNotification.Name = NSNotification.Name("GoToMenu")
}
