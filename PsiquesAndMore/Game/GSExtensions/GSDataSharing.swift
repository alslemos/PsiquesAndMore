//
//  GSDataSharing.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func sendPlayerData(completion: @escaping (() -> Void)) {
        do {
            guard let data = try? JSONEncoder().encode(players) else { return }
            try match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send data failed")
        }
    }
    
    func sendMovementData(_ movement: Movement, _ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode(movement) else { return }
            try match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send data failed")
        }
    }
    
    func sendControlsData(_ controls: Controls) {
        do {
            guard let data = try? JSONEncoder().encode(controls) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    func sendNotificationData(_ notification: NotificationType, _ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode(notification.data) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print(notification.dataError)
        }
    }
}
