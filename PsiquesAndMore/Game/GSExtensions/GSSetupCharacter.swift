//
//  GSSetupCharacter.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 03/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupCharacter() {
        print("Disparando personagem")
        
        let pb = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30), center: CGPoint(x: 0, y: square.frame.height / 2))
        
        //      pb.contactTestBitMask = 0x00000001
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        //      pb.node?.physicsBody?.mass = 16.0
        pb.node?.physicsBody?.friction = 0.0
        
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        square.physicsBody = pb
        square.name = "square"
        square.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)! + 100)
        
        self.addChild(square)
        createLimits()
    }
    
    func moveSpriteUP() {
        print("moving up")
//        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
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
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 0))
    }
    
    func moveSpriteRight() {
        print("moving right")
//        square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
        
        self.square.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 0))
    }
    
    func moveMountainUp() {
        print("moveMountainUp")
        square.run(.move(to: CGPoint(x: square.position.x - 20, y: square.position.y + 15), duration: 0.2))
    }
    
    
    // talvez tenha de ir para a GameScene
    // alterar o valor pelo publisher do combine!
    override func update(_ currentTime: TimeInterval) {
        square.physicsBody?.applyForce(CGVector(dx: characterVelocity, dy: 0))
        
        if Int.random(in: 0...20) > 19 {
            characterVelocity += 1
            print(characterVelocity)
        }
        
        // moveMountainUp()
        // vai aumentar
    }
    
    func createLimits() {
        guard let view = self.view else { return }
        
        let maxLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: view.frame.height))
        maxLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        maxLimitNode.position = CGPoint(x: view.frame.width, y: 0)
        
        let maxLimitBody = SKPhysicsBody(rectangleOf: maxLimitNode.size, center: CGPoint(x: square.frame.width / 2, y: view.frame.height / 2))
        maxLimitBody.allowsRotation = false
        maxLimitBody.isDynamic = false
        maxLimitBody.affectedByGravity = false
        
        maxLimitNode.physicsBody = maxLimitBody
        
        let minLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: view.frame.height))
        minLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        minLimitNode.position = CGPoint(x: view.frame.width * 0.1, y: 0)
        
        let minLimitBody = SKPhysicsBody(rectangleOf: minLimitNode.size, center: CGPoint(x: square.frame.width / 2, y: view.frame.height / 2))
        minLimitBody.allowsRotation = false
        minLimitBody.isDynamic = false
        minLimitBody.affectedByGravity = false
        
        minLimitNode.physicsBody = minLimitBody
        
        addChild(maxLimitNode)
        addChild(minLimitNode)
    }
}

