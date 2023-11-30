//
//  DtHDataSharing.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    // movement data
    func sendMovementData(_ movement: Movement) {
        do {
            guard let data = try? JSONEncoder().encode(movement) else { return }
            try match?.sendData(toAllPlayers: data, with: .unreliable)
        } catch {
            print("send movement data failed")
        }
    }
    
    // player data
    func sendPlayerData() {
        do {
            guard let data = try? JSONEncoder().encode(players) else { return }
            try match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send players data failed")
        }
    }
    
    // controls data
    func sendControlsData(_ controls: Controls) {
        do {
            guard let data = try? JSONEncoder().encode(controls) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    // obstacles data
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
    
    func sendLifeData() {
        print("sending life data")
        do {
            guard let data = try? JSONEncoder().encode("damage") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send life data failed")
        }
    }
    
    func sendInstaKillData() {
        print("sending insta kill data")
        do {
            guard let data = try? JSONEncoder().encode("instaKill") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send insta kill data failed")
        }
    }
}
