//
//  GSHostOnlyFunctions.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func setupHostOnlyFunctions(for game: Game) {
        switch game {
            case .hill:
                self.createObstaclesArray()
                
                self.savePlayers()
            case .squid:
                createFallingOrderArray()
                
                sendFallingOrderData()
                setupPlatforms()
            case .snake:
                print("foo")
        }
    }    
}
