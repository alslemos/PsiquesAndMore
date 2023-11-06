//
//  GSSetupCharacter.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 03/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupCharacter(){
        square = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let physicsBodyCharacter = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
        physicsBodyCharacter.contactTestBitMask = 0x00000001
        physicsBodyCharacter.affectedByGravity = false
        physicsBodyCharacter.allowsRotation = false
        physicsBodyCharacter.isDynamic = true
        
        square.physicsBody = physicsBodyCharacter
        square.name = "character"
        square.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        
        self.addChild(square)
    }
    
    func moveSpriteUP() {
       print("moving up")
       square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
   }
   
   // moveu para baixo
    func moveSpriteDown() {
       print("moving down")
       square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
   }
   
   // moveu para a esquerda
    func moveSpriteLeft() {
       print("moving left")
       square.run(.move(to: CGPoint(x: square.position.x - 10, y: square.position.y), duration: 0.2))
       
   }
   
    func moveSpriteRight() {
       print("moving right")
       square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
   }
   
}
