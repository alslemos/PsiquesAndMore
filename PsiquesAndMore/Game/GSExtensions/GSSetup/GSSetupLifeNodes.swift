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
            let heart = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "heart.fill") ?? UIImage()))
            
            aux += heart.size.width + 8
            
            heart.position = CGPoint(x: viewFrame.minX + aux, y: viewFrame.maxY - 32)
            heart.zPosition = 10
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
                self.lifeNodes[0].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
            case 1:
                self.lifeNodes[0].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
                self.lifeNodes[1].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
            case 0:
                self.lifeNodes[0].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
                self.lifeNodes[1].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
                self.lifeNodes[2].texture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
                
                #warning("uncomment this afterwards")
//                self.sendNotificationData(.gameOver) {
//                    self.notify(.gameOver)
//                }
            default:
                print("tried to update lifeNodes with <0 hearts")
        }
    }
}

