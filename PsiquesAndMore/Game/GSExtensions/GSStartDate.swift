//
//  GSStartDate.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

extension GameScene {
    func getStartDate(_ completion: @escaping () -> ()) {
        startDate = Date.now
        print("date: \(startDate)")

        guard let date = startDate else { return }

        sendStartData(date) {
            completion()
        }
    }

    func sendStartData(_ date: Date, _ completion: @escaping () -> ()) {
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
