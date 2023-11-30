//
//  Platform.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupPlatforms() {
        print("setting up scenario")
        for i in 0..<8 {
            setupPlatform(index: i)
        }
    }
    
    func setupPlatform(index: Int) {
        print("setting platform\(index)")
        
        let platform = SKSpriteNode(texture: Textures.rockTexture, size: CGSize(width: 100, height: 100))
        
        if index < 2 {
            let yPosition = viewFrame.midY + (index == 0 ? 100 : (-100))
            platform.position = CGPoint(x: viewFrame.midX - 180, y: yPosition)
        }
        
        if index > 1 && index < 4 {
            let yPosition = viewFrame.midY + (index == 2 ? 100 : (-100))
            platform.position = CGPoint(x: viewFrame.midX - 60, y: yPosition)
        }
        
        if index > 3 && index < 6 {
            let yPosition = viewFrame.midY + (index == 4 ? 100 : (-100))
            platform.position = CGPoint(x: viewFrame.midX + 60, y: yPosition)
        }
        
        if index > 5 && index < 8 {
            let yPosition = viewFrame.midY + (index == 6 ? 100 : (-100))
            platform.position = CGPoint(x: viewFrame.midX + 180, y: yPosition)
        }
        
        platform.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        platform.color = fallingOrder[index] ? .red : .blue
        platform.name = "platform\(index)"
        platform.zPosition = Layers.particle
        
        platforms.append(platform)
        
        self.addChild(platform)
    }
}
