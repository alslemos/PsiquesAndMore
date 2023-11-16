//
//  GSSpawnTrees.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 13/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setUpTree(_ completion: @escaping (SKSpriteNode) -> ()) {
        let tree = SKSpriteNode(texture: SKTexture(imageNamed: "fullTree"), size: CGSize(width: 80, height: 80))
        tree.anchorPoint = CGPoint(x: 0, y: 0)
        tree.position = CGPoint(x: viewFrame.maxX, y: -100)
        tree.zPosition = 1
        tree.zRotation = -(rotationAngle)
        tree.name = "tree"
        
        let physicsBodyTree = SKPhysicsBody(rectangleOf: tree.size, center: CGPoint(x: tree.size.width / 2, y: tree.size.height / 2))
        
        physicsBodyTree.affectedByGravity = false
        physicsBodyTree.allowsRotation = false
        physicsBodyTree.isDynamic = true
        
        physicsBodyTree.categoryBitMask = PhysicsCategory.obstacleNode
        physicsBodyTree.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyTree.collisionBitMask = PhysicsCategory.floorNode
        
        tree.physicsBody = physicsBodyTree
        
        self.addChild(tree)
        self.obstacles.append(tree)
        
        completion(tree)
    }
    
    func moveTree(tree: SKSpriteNode) {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
        
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        tree.run(SKAction.repeatForever(moveAction))
    }
}
