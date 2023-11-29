//
//  GSHostOnlyFunctions.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func setupHostOnlyFunctions(for game: Game, _ completion: @escaping () -> ()) {
        switch game {
            case .hill:
                self.createObstaclesArray()
                
                self.savePlayers {
                    completion()
                }
            case .snake:
                print("foo")
            case .squid:
                createFallingOrderArray()
                
                sendFallingOrderData {
                    self.setupPlatforms()
                    completion()
                }
        }
    }    
}
