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
        guard let localIndex = self.localPlayerIndex else { return }
        
        self.setupPauseButton()
        self.setupCharacter()
        self.setupFloor()
        self.setupBackground()
        self.setupAvalanche()
        self.setupTimer()
        self.setupLifeNodes()
        
        if localIndex == 0 {
            self.createObstaclesArray()
        }
        
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
                let currentDate = Date.now
                let numberOfSeconds = Int(currentDate.timeIntervalSince1970)
                
                print("debug: start date: \(startDate)")
                print("debug: current date: \(numberOfSeconds)")
                
                if numberOfSeconds == startDate + 4 {
                    self.didGameStart = true
                }
            }
    }
}
