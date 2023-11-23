//
//  GSDataSharing.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    // MARK: - Player data
    func sendPlayerData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode(players) else { return }
            try match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send players data failed")
        }
    }
    
    // MARK: - Movement data
    func sendMovementData(_ movement: Movement, _ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode(movement) else { return }
            try match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send movement data failed")
        }
    }
    
    // MARK: - Controls data
    func sendControlsData(_ controls: Controls) {
        do {
            guard let data = try? JSONEncoder().encode(controls) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    // MARK: - Notification data
    func sendNotificationData(_ notification: NotificationType, _ completion: @escaping () -> ()) {
        print("sending notification data")
        do {
            guard let data = try? JSONEncoder().encode(notification.data) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print(notification.dataError)
        }
    }
    
    // MARK: - Obstacles data
    func sendEnemiesMovements() {
        print("sending enemies movements data")
        do {
            guard let data = try? JSONEncoder().encode(enemiesMovements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send enemies movements data failed")
        }
    }
    
    func sendObstaclesOrder() {
        print("sending obstacles order data")
        do {
            guard let data = try? JSONEncoder().encode(obstaclesOrder) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send obstacles order data failed")
        }
    }
}
