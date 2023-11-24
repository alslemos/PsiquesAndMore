//
//  GSSpawnTrees.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 13/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupTree() {
        tree.anchorPoint = CGPoint(x: 0, y: 1)
        tree.position = CGPoint(x: viewFrame.maxX, y: tree.size.height - 8)
        tree.zPosition = Layers.entity
        tree.zRotation = -(rotationAngle)
        tree.name = "tree"
        
        let branchWidth = tree.size.width * 3.4
        let branchHeigth = branchWidth * 1.5
        
        let branch = SKSpriteNode(texture: Textures.branchTexture, size: CGSize(width: branchWidth, height: branchHeigth))
        branch.anchorPoint = CGPoint(x: 0, y: 0.97)
        
        tree.addChild(branch)
        
        let physicsBodyTree = SKPhysicsBody(rectangleOf: CGSize(width: tree.size.width / 2, height: tree.size.height / 4), center: CGPoint(x: tree.size.width / 2, y: -(tree.size.width / 6)))
        
        physicsBodyTree.affectedByGravity = false
        physicsBodyTree.allowsRotation = false
        physicsBodyTree.isDynamic = true
        
        physicsBodyTree.categoryBitMask = PhysicsCategory.obstacleNode
        physicsBodyTree.contactTestBitMask = PhysicsCategory.characterNode
        physicsBodyTree.collisionBitMask = PhysicsCategory.floorNode
        
        tree.physicsBody = physicsBodyTree
        
        self.addChild(tree)
    }
    
    func moveTree() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
        
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        self.tree.run(SKAction.repeatForever(moveAction))
    }
}
