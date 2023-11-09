//
//  GSSetupGame.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import GameKit

extension GameScene {
    func setGame(_ completion: @escaping () -> ()) {
        self.setupPauseButton()
        self.setupCharacter()
        self.setupFloor()
        self.setupBackground()
        self.setupTimer()
        self.createObstaclesArray()
        self.savePlayers {
            completion()
        }
    }
    
    func startGamePublisher() {
        print("starting game publisher")

        startGameSubscription = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
            .map { _ in
                return self.startDate
            }
            .sink { startDate in
                guard let date = startDate else { return }

                let calendar = Calendar.current
                let startSeconds = calendar.component(.second, from: date)
                let startMinutes = calendar.component(.minute, from: date)

                let currentDate = Date.now
                let currentSeconds = calendar.component(.second, from: currentDate)
                let currentMinutes = calendar.component(.minute, from: currentDate)

                if currentMinutes == startMinutes && currentSeconds == startSeconds + 4 {
                    self.didGameStart = true
                }
            }
    }
}
