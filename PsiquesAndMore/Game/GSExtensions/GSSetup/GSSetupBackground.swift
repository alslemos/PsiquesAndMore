//
//  GSSetupFloor.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupBackground(){
        backgroundImage.zPosition = 0
        backgroundImage.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)

        addChild(backgroundImage)
    }
    
    // MARK: - Background Subscription
    func createBackgroundPositionUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= -(self.viewFrame.width) {
                    self.rectangle.position = CGPoint(x: 0, y: self.verticalThresholdPoint)
                }
            }.store(in: &cancellables)
    }
    
    func createBackgroundVelocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
}



