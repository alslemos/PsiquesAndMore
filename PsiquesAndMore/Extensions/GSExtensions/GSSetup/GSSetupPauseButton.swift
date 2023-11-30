//
//  GSSetupPauseButton.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 01/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupPauseButton(for game: Game) {
        
        switch game {
            case .hill:
                
                print("setting up pause button")
                
                let pauseButton = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "pause.fill") ?? UIImage()))
                pauseButton.size = CGSize(
                    width: 32,
                    height: 32)
                pauseButton.position = CGPoint(
                    x: self.frame.maxX - 64,
                    y: self.frame.maxY - 64)
                pauseButton.zPosition = Layers.UIElement
                pauseButton.name = "pauseButton"
                self.pauseButton = pauseButton
                self.addChild(pauseButton)
                
            case .squid:
                
                print("setting up pause button")
                
                let backButton = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "arrowshape.turn.up.backward.fill") ?? UIImage()))
                backButton.size = CGSize(
                    width: 32,
                    height: 32)
                backButton.position = CGPoint(
                    x: self.frame.maxX - 64,
                    y: self.frame.maxY - 64)
                backButton.zPosition = Layers.UIElement
                backButton.name = "backButton"
                self.pauseButton = backButton
                self.addChild(backButton)
                
            case .snake:
                print("foo")
        }
    }
}
