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
        
        let pb = SKPhysicsBody(rectangleOf: square.size, center: CGPoint(x: square.size.width / 2, y: square.size.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = PhysicsCategory.characterNode
        pb.contactTestBitMask = PhysicsCategory.obstacleNode + PhysicsCategory.avalancheNode
        pb.collisionBitMask = PhysicsCategory.floorNode + PhysicsCategory.limitNode
        
        square.anchorPoint = CGPoint(x: 0, y: 0)
        square.physicsBody = pb
        square.name = "square"
        square.position = CGPoint(x: (viewFrame.midX), y: (viewFrame.midY) + 100)
        square.zPosition = 1
        
        let emitter = SKEmitterNode(fileNamed: "Snow")
        emitter?.position = CGPoint(x: 0.0, y: 0.0)
        emitter?.particleSize = CGSize(width: 32, height: 32)
        emitter?.zRotation = -rotationAngle
        emitter?.particleBirthRate = 0
        emitter?.zPosition = 10
        emitter?.name = "snow"
        emitter?.targetNode = self.scene
        self.snowParticle = emitter ?? SKEmitterNode()
        square.addChild(snowParticle)
        
        self.addChild(square)
        createLimits()
        
        updateAsset()
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
        
        maxLimitBody.categoryBitMask = PhysicsCategory.limitNode
        maxLimitBody.collisionBitMask = PhysicsCategory.characterNode
        
        maxLimitNode.physicsBody = maxLimitBody
        
        let minLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height * 3))
        
        minLimitNode.name = "minLimit"
        minLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        minLimitNode.position = CGPoint(x: viewFrame.width * 0.1, y: 0)
        
        let minLimitBody = SKPhysicsBody(rectangleOf: minLimitNode.size, center: CGPoint(x: minLimitNode.frame.width / 2, y: minLimitNode.frame.height / 2))
        
        minLimitBody.allowsRotation = false
        minLimitBody.isDynamic = false
        minLimitBody.affectedByGravity = false
        
        minLimitBody.categoryBitMask = PhysicsCategory.limitNode
        minLimitBody.collisionBitMask = PhysicsCategory.characterNode
        
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
                    self.characterVelocity += 2
                    
                    let applyImpulse = SKAction.applyImpulse(CGVector(dx: -(self.characterVelocity), dy: 0), duration: 1)
                    self.square.run(applyImpulse)
                }
            }.store(in: &cancellables)
    }
    
    func updateAsset() {
        print("debug: texture atlas: \(textureAtlasss.textureNames.count)")
        
        for i in 0..<textureAtlasss.textureNames.count {
            let textureNames = "animada" + String(i)
            entidadeFrames.append(textureAtlasss.textureNamed(textureNames))
        }

        print(entidadeFrames.count)
        
        square.run(SKAction.repeatForever(SKAction.animate(with: entidadeFrames, timePerFrame: 0.15)))
    }
    
    func updateAssetSeAbaixando() {
        print("debug: texture atlas abaixando: \(textureAtlassAbaixando.textureNames.count)")
        
        for i in 0..<textureAtlassAbaixando.textureNames.count {
            let textureNames = "Vector" + "+" + String(i)
            entidadeFramesAbaixando.append(textureAtlassAbaixando.textureNamed(textureNames))
        }
        print(entidadeFramesAbaixando.count)
        
        square.run(SKAction.animate(with: entidadeFramesAbaixando, timePerFrame: 0.15))
    }
}

