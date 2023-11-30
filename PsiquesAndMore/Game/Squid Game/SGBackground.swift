//
//  SGBackground.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupSquidBackground() {
        let node = SKSpriteNode(texture: Textures.lavaTexture, size: CGSize(
            width: viewFrame.width,
            height: viewFrame.height))
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: viewFrame.midX, y: viewFrame.midY)
        node.name = "background"
        node.zPosition = 0
        
        self.addChild(node)
    }
}
