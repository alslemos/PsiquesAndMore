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
        
//              pb.contactTestBitMask = 0x00000001
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        //      pb.node?.physicsBody?.mass = 16.0
        pb.node?.physicsBody?.friction = 0.0
        pb.categoryBitMask = 1
        pb.contactTestBitMask = 4
        
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        square.physicsBody = pb
        square.name = "square"
        square.position = CGPoint(x: (viewFrame.midX), y: (viewFrame.midY) + 100)
        square.zPosition = 1
        
        self.addChild(square)
        createLimits()
    }
    
//    // talvez tenha de ir para a GameScene
//    // alterar o valor pelo publisher do combine!
//    override func update(_ currentTime: TimeInterval) {
////        square.physicsBody?.applyForce(CGVector(dx: -(characterVelocity), dy: 0))
//        square.physicsBody?.applyImpulse(CGVector(dx: -(characterVelocity), dy: 0))
//        
////        if Int.random(in: 0...20) > 16 {
//        characterVelocity += 0.1
//            print("DEBUG: CHARACTER VELOCITY \(characterVelocity)")
////        }
//        
//        // moveMountainUp()
//        // vai aumentar
//    }
    
    func createLimits() {
        let maxLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height * 3))
        maxLimitNode.name = "maxLimit"
        maxLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        maxLimitNode.position = CGPoint(x: viewFrame.width - 50, y: 0)
        
        let maxLimitBody = SKPhysicsBody(rectangleOf: maxLimitNode.size, center: CGPoint(x: maxLimitNode.frame.width / 2, y: maxLimitNode.frame.height / 2))
        maxLimitBody.allowsRotation = false
        maxLimitBody.isDynamic = false
        maxLimitBody.affectedByGravity = false
        maxLimitBody.categoryBitMask = 8
        maxLimitBody.collisionBitMask = 1
        
        maxLimitNode.physicsBody = maxLimitBody
        
        let minLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height * 3))
        minLimitNode.name = "minLimit"
        minLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        minLimitNode.position = CGPoint(x: viewFrame.width * 0.1, y: 0)
        
        let minLimitBody = SKPhysicsBody(rectangleOf: minLimitNode.size, center: CGPoint(x: minLimitNode.frame.width / 2, y: minLimitNode.frame.height / 2))
        minLimitBody.allowsRotation = false
        minLimitBody.isDynamic = false
        minLimitBody.affectedByGravity = false
        minLimitBody.categoryBitMask = 8
        minLimitBody.collisionBitMask = 1
        
        minLimitNode.physicsBody = minLimitBody
        
        addChild(maxLimitNode)
        addChild(minLimitNode)
    }
}

