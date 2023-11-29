//
//  GSSetupCommands.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import GameController
import SpriteKit

extension GameScene {
    func setupControls(for game: Game) {
        switch game {
            case .hill:
                setupVirtualController()
            case .snake:
                print("foo")
            case .squid:
                setupSquidControls()
        }
    }
}


