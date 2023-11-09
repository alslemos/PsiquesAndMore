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
        square.position = CGPoint(x: (viewFrame.midX), y: (viewFrame.midY) + 100)
        square.zPosition = 1
        
        self.addChild(square)
//        createLimits()
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
        let maxLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height))
        maxLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        maxLimitNode.position = CGPoint(x: viewFrame.width, y: 0)
        
        let maxLimitBody = SKPhysicsBody(rectangleOf: maxLimitNode.size, center: CGPoint(x: square.frame.width / 2, y: viewFrame.height / 2))
        maxLimitBody.allowsRotation = false
        maxLimitBody.isDynamic = false
        maxLimitBody.affectedByGravity = false
        
        maxLimitNode.physicsBody = maxLimitBody
        
        let minLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height))
        minLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        minLimitNode.position = CGPoint(x: viewFrame.width * 0.1, y: 0)
        
        let minLimitBody = SKPhysicsBody(rectangleOf: minLimitNode.size, center: CGPoint(x: square.frame.width / 2, y: viewFrame.height / 2))
        minLimitBody.allowsRotation = false
        minLimitBody.isDynamic = false
        minLimitBody.affectedByGravity = false
        
        minLimitNode.physicsBody = minLimitBody
        
        addChild(maxLimitNode)
        addChild(minLimitNode)
    }
}

