//
//  GSMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 09/11/23.
//

import Foundation

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
