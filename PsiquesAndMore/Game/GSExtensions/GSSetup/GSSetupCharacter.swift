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
        
        let pb = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30), center: CGPoint(x: square.size.width / 2, y: square.size.height / 2))
        
//              pb.contactTestBitMask = 0x00000001
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        //      pb.node?.physicsBody?.mass = 16.0
//        pb.node?.physicsBody?.friction = 0.0
        pb.categoryBitMask = 1
        pb.contactTestBitMask = 4
        
        square.anchorPoint = CGPoint(x: 0, y: 0)
        square.physicsBody = pb
        square.name = "square"
        square.position = CGPoint(x: (viewFrame.midX), y: (viewFrame.midY) + 100)
        square.zPosition = 1
        
        let emitter = SKEmitterNode(fileNamed: "Snow")
        emitter?.position = CGPoint(x: 0.0, y: 0.0)
        emitter?.particleSize = CGSize(width: 32, height: 32)
        emitter?.zRotation = -rotationAngle
        emitter?.zPosition = 10
        emitter?.name = "snow"
        emitter?.targetNode = self.scene
        self.snowParticle = emitter ?? SKEmitterNode()
        square.addChild(snowParticle)
        
        self.addChild(square)
        createLimits()
    }
    
    func toggleSnowParticles() {
        
        if snowParticle.particleBirthRate <= 0 {
            self.snowParticle.particleBirthRate = 40.0
        } else {
            self.snowParticle.particleBirthRate = 0
        }
        
    }
    
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
    
    func createCharacterVelocityUpdater() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                if self.isPaused {
                    return count
                } else {
                    return count + 1
                }
            }
            .sink { count in
                if !self.isPaused {
                    self.characterVelocity += 1
                    
                    let applyImpulse = SKAction.applyImpulse(CGVector(dx: -(self.characterVelocity), dy: 0), duration: 1)
                    self.square.run(applyImpulse)
                }
            }.store(in: &cancellables)
    }
}

