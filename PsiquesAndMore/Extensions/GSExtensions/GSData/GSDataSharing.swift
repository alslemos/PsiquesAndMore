//
//  GSDataSharing.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    // notification data
    func sendNotificationData(_ notification: GameState) {
        print("sending notification data")
        do {
            guard let data = try? JSONEncoder().encode(notification.rawValue) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print(notification.dataError)
        }
    }
}
