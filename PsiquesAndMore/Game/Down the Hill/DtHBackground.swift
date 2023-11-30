//
//  DtHBackground.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupDownTheHillBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
        backgroundImage.zPosition = Layers.background
        backgroundImage.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)

        addChild(backgroundImage)
    }
}
