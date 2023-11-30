//
//  SGDataSharing.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    // movement data
    func sendStepData(_ movement: String) {
        do {
            guard let data = try? JSONEncoder().encode(movement) else { return }
            try match?.sendData(toAllPlayers: data, with: .unreliable)
        } catch {
            print("send movement data failed")
        }
    }
    
    func sendFallingOrderData() {
        print("sending will falling order data")
        do {
            guard let data = try? JSONEncoder().encode(fallingOrder) else { return }
            try self.matchManager?.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send will falling order data failed")
        }
    }
}
