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
    
    func sendPauseGameData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("pauseGame") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send pause game data failed")
        }
    }
    
    func sendContinueGameData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("continueGame") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send continue game data failed")
        }
    }
    
    func sendGoToMenuData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("goToMenu") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send back to menu data failed")
        }
    }
    
    func sendGameOverData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("gameOver") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send game over data failed")
        }
    }
    
    func sendPlayAgainData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("playAgain") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send play again data failed")
        }
    }
}
