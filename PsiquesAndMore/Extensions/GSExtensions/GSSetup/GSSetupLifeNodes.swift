//
//  GSSetupLifeNodes.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 14/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupLifeNodes() {
        var aux: CGFloat = 0
        
        for i in 0..<3 {
            let heart = SKSpriteNode(texture: Textures.heartFillTexture)
            
            aux += heart.size.width + 8
            
            heart.position = CGPoint(x: viewFrame.minX + aux, y: viewFrame.maxY - 40)
            heart.zPosition = Layers.UIElement
            heart.name = "heart\(i + 1)"
            
            self.lifeNodes.append(heart)
        }
        
        for i in 0..<lifeNodes.count {
            self.addChild(lifeNodes[i])
        }
    }
    
    func updateLifeNodes() {
        switch(lifes) {
            case 2:
                self.lifeNodes[0].texture = Textures.heartTexture
            case 1:
                self.lifeNodes[0].texture = Textures.heartTexture
                self.lifeNodes[1].texture = Textures.heartTexture
            case 0:
                self.lifeNodes[0].texture = Textures.heartTexture
                self.lifeNodes[1].texture = Textures.heartTexture
                self.lifeNodes[2].texture = Textures.heartTexture
                
                self.sendNotificationData(.gameOver) {
                    self.notify(.gameOver)
                }
            default:
                print("tried to update lifeNodes with <0 hearts")
        }
    }
}

