//
//  GSMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func moveSprite(_ movement: Movement) {
        switch movement {
            case .up:
                self.square.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
            case .down:
                self.setSpriteDownBody()
            case .right:
                self.square.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
            case .left:
                self.square.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
        }
    }
    
    func setSpriteDownBody() {
        let originalSquareSize: CGSize = square.size
        
        square.size = CGSize(width: originalSquareSize.width, height: originalSquareSize.height / 2)
        
        let pb = SKPhysicsBody(rectangleOf: square.size, center: CGPoint(x: square.size.width / 2, y: square.frame.height / 2))
        
        square.physicsBody = pb
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.square.size = originalSquareSize
            
            let pb = SKPhysicsBody(rectangleOf: self.square.size, center: CGPoint(x: self.square.size.width / 2, y: self.square.size.height / 2))
            
            self.square.physicsBody = pb
        }
    }
}

enum Movement: Codable {
    case up
    case down
    case left
    case right
}
