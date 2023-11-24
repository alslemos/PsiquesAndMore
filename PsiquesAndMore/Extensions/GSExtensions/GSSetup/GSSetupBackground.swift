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
        backgroundImage.zPosition = Layers.background
        backgroundImage.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)

        addChild(backgroundImage)
    }
}



