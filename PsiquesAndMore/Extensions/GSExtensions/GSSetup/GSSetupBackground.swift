//
//  GSSetupFloor.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupBackground(for game: Game) {
        switch game {
            case .hill:
                setupDownTheHillBackground()
            case .squid:
                setupSquidBackground()
            case .snake:
                print("foo")
        }
    }    
}

