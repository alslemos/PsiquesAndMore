//
//  GSStartDate.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func getStartDate(_ completion: @escaping () -> ()) {
        let currentDate = Date.now
        
        let numberOfSeconds = Int(currentDate.timeIntervalSince1970)
        
        startDate = numberOfSeconds
        
        print("date: \(startDate)")

        sendStartData(numberOfSeconds) {
            completion()
        }
    }

    func sendStartData(_ date: Int, _ completion: @escaping () -> ()) {
        print("sending start date data")
        do {
            guard let data = try? JSONEncoder().encode(date) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send start date data failed")
        }
    }
}
