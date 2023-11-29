//
//  GSNotifications.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func notify(_ notification: GameState) {
        NotificationCenter.default.post(name: notification.name, object: nil)
    }
}
