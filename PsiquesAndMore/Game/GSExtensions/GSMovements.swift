//
//  GSMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func moveSpriteUP() {
        print("moving up")
//        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
    }
    
    // moveu para baixo
    func moveSpriteDown() {
        print("moving down")
//        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -15))
        
        let originalSquareSize: CGSize = square.size
        
        square.size = CGSize(width: originalSquareSize.width, height: originalSquareSize.height / 2)
        square.physicsBody = SKPhysicsBody(rectangleOf: square.size, center: CGPoint(x: 0, y: square.frame.height / 2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.square.size = CGSize(width: originalSquareSize.width, height: originalSquareSize.height)
            self.square.physicsBody = SKPhysicsBody(rectangleOf: self.square.size, center: CGPoint(x: 0, y: self.square.frame.height / 2))
        }
    }
    
    // moveu para a esquerda
    func moveSpriteLeft() {
        print("moving left")
//        square.run(.move(to: CGPoint(x: square.position.x - 50, y: square.position.y), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
        
    }
    
    func moveSpriteRight() {
        print("moving right")
//        square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
        
    }
    
    func moveMountainUp() {
        print("moveMountainUp")
        square.run(.move(to: CGPoint(x: square.position.x - 20, y: square.position.y + 15), duration: 0.2))
    }
}

enum Movement: Codable {
    case up
    case down
    case left
    case right
}
