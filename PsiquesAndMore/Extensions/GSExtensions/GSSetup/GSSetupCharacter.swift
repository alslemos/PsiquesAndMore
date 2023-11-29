//
//  GSSetupCharacter.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 03/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupCharacter(for game: Game) {
        switch game {
            case .hill:
                setupSkater()
            case .snake:
                print("foo")
            case .squid:
                setupDinosaur()
        }
    }
    // MARK: - Down the Hill Game
    func setupSkater() {
        print("Disparando personagem")
        
        character = SKSpriteNode(texture: SKTexture(imageNamed: "animated0"), size: CGSize(width: 60, height: 60))
        
        let pb = SKPhysicsBody(rectangleOf: character.size, center: CGPoint(x: character.size.width / 2, y: character.size.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = DownTheHillPhysicsCategory.characterNode
        pb.contactTestBitMask = DownTheHillPhysicsCategory.obstacleNode + DownTheHillPhysicsCategory.avalancheNode
        pb.collisionBitMask = DownTheHillPhysicsCategory.floorNode + DownTheHillPhysicsCategory.limitNode
        
        character.anchorPoint = CGPoint(x: 0, y: 0)
        character.physicsBody = pb
        character.name = "square"
        character.position = CGPoint(x: (viewFrame.midX), y: (viewFrame.midY) + 100)
        character.zPosition = Layers.entity
        
        let emitter = SKEmitterNode(fileNamed: "Snow")
        emitter?.position = CGPoint(x: 0.0, y: 0.0)
        emitter?.particleSize = CGSize(width: 32, height: 32)
        emitter?.zRotation = -rotationAngle
        emitter?.particleBirthRate = 0
        emitter?.zPosition = Layers.particle
        emitter?.name = "snow"
        emitter?.targetNode = self.scene
        self.snowParticle = emitter ?? SKEmitterNode()
        character.addChild(snowParticle)
        
        self.addChild(character)
        createLimits()
        createPositionSyncLimits()
        
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
        
        maxLimitBody.categoryBitMask = DownTheHillPhysicsCategory.limitNode
        maxLimitBody.collisionBitMask = DownTheHillPhysicsCategory.characterNode
        
        maxLimitNode.physicsBody = maxLimitBody
        
        let minLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: viewFrame.height * 3))
        
        minLimitNode.name = "minLimit"
        minLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        minLimitNode.position = CGPoint(x: 0, y: 0)
        
        let minLimitBody = SKPhysicsBody(rectangleOf: minLimitNode.size, center: CGPoint(x: minLimitNode.frame.width / 2, y: minLimitNode.frame.height / 2))
        
        minLimitBody.allowsRotation = false
        minLimitBody.isDynamic = false
        minLimitBody.affectedByGravity = false
        
        minLimitBody.categoryBitMask = DownTheHillPhysicsCategory.limitNode
        minLimitBody.collisionBitMask = DownTheHillPhysicsCategory.characterNode
        
        minLimitNode.physicsBody = minLimitBody
        
        addChild(maxLimitNode)
        addChild(minLimitNode)
    }
    
    func createPositionSyncLimits() {
        // right sync node
        let rightSyncLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: viewFrame.height * 3))
        
        rightSyncLimitNode.name = "rightSyncLimit"
        rightSyncLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        rightSyncLimitNode.position = CGPoint(x: viewFrame.midX + 40, y: 0)
        rightSyncLimitNode.zPosition = Layers.limit
        
        let rightSyncLimitNodePhysicsBody = SKPhysicsBody(rectangleOf: rightSyncLimitNode.size, center: CGPoint(x: rightSyncLimitNode.frame.width / 2, y: rightSyncLimitNode.frame.height / 2))
        
        rightSyncLimitNodePhysicsBody.allowsRotation = false
        rightSyncLimitNodePhysicsBody.isDynamic = false
        rightSyncLimitNodePhysicsBody.affectedByGravity = false
        
        rightSyncLimitNodePhysicsBody.categoryBitMask = DownTheHillPhysicsCategory.limitNode
        rightSyncLimitNodePhysicsBody.collisionBitMask = DownTheHillPhysicsCategory.characterNode
        
        rightSyncLimitNode.physicsBody = rightSyncLimitNodePhysicsBody
        
        self.addChild(rightSyncLimitNode)
        
        // left sync node
        
        let leftSyncLimitNode = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: viewFrame.height * 3))
        
        leftSyncLimitNode.name = "leftSyncLimit"
        leftSyncLimitNode.anchorPoint = CGPoint(x: 0, y: 0)
        leftSyncLimitNode.position = CGPoint(x: viewFrame.midX - 40, y: 0)
        leftSyncLimitNode.zPosition = Layers.limit
        
        let leftSyncLimitNodePhysicsBody = SKPhysicsBody(rectangleOf: leftSyncLimitNode.size, center: CGPoint(x: leftSyncLimitNode.frame.width / 2, y: leftSyncLimitNode.frame.height / 2))
        
        leftSyncLimitNodePhysicsBody.allowsRotation = false
        leftSyncLimitNodePhysicsBody.isDynamic = false
        leftSyncLimitNodePhysicsBody.affectedByGravity = false
        
        leftSyncLimitNodePhysicsBody.categoryBitMask = DownTheHillPhysicsCategory.limitNode
        leftSyncLimitNodePhysicsBody.collisionBitMask = DownTheHillPhysicsCategory.characterNode
        
        leftSyncLimitNode.physicsBody = leftSyncLimitNodePhysicsBody
        
        self.addChild(leftSyncLimitNode)
    }
    
    func removePositionSyncLimits() {
        self.childNode(withName: "rightSyncLimit")?.removeFromParent()
        self.childNode(withName: "leftSyncLimit")?.removeFromParent()
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
                    
                    let applyForce = SKAction.applyForce(CGVector(dx: -(self.characterVelocity), dy: 0), duration: 1)
                    self.character.run(applyForce)
                }
            }.store(in: &cancellables)
    }
    
    func updateAsset() {
        print("debug: texture atlas: \(animatedTextureAtlas.textureNames.count)")
        
        for i in 0..<animatedTextureAtlas.textureNames.count {
            let textureNames = "animated" + String(i)
            animatedEntityFrames.append(animatedTextureAtlas.textureNamed(textureNames))
        }
        
        print(animatedEntityFrames.count)
        
        character.run(SKAction.repeatForever(SKAction.animate(with: animatedEntityFrames, timePerFrame: 0.15)))
    }
    
    func updateAssetSeAbaixando() {
        print("debug: texture atlas abaixando: \(loweredTextureAtlas.textureNames.count)")
        
        for i in 0..<loweredTextureAtlas.textureNames.count {
            let textureNames = "lowered" + String(i)
            loweredEntityFrames.append(loweredTextureAtlas.textureNamed(textureNames))
        }
        print(loweredEntityFrames.count)
        
        character.run(SKAction.animate(with: loweredEntityFrames, timePerFrame: 0.15))
    }
    
    // MARK: - Squid Game
    func setupDinosaur() {
        character = SKSpriteNode(color: .yellow, size: CGSize(width: 40, height: 40))
        
        character.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        character.position = CGPoint(x: viewFrame.minX + 80, y: viewFrame.midY)
        character.name = "character"
        character.zPosition = Layers.entity
        
        self.addChild(character)
        setupLines()
    }
    
    func setupLines() {
        setupStartLine()
        setupFinishLine()
    }
    
    func setupStartLine() {
        let node = SKSpriteNode(texture: Textures.groundTexture, size: CGSize(
            width: 120,
            height: viewFrame.height + 100))
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: viewFrame.minX + 60, y: viewFrame.midY)
        node.zPosition = Layers.particle
        node.name = "startLine"
        
        self.addChild(node)
    }
    
    func setupFinishLine() {
        let node = SKSpriteNode(texture: Textures.groundTexture, size: CGSize(
            width: 120,
            height: viewFrame.height + 100))
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: viewFrame.maxX - 60, y: viewFrame.midY)
        node.zPosition = Layers.particle
        node.name = "finishLine"
        
        self.addChild(node)
    }
}

