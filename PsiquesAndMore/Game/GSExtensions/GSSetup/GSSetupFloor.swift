//
//  GSSetupFloor.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func setupFloor() {
        var rectangleWidth: CGFloat = 0
        var rectangleHeigth: CGFloat = 0
        
        verticalThresholdPoint = (viewFrame.height) * 0.58
        
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) +
                              ((viewFrame.width) * (viewFrame.width)))
        
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        
        square.zRotation = -(rotationAngle)
        
        rectangleHeigth = sin(rotationAngle) * (viewFrame.width)

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!),
                                 size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
      
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0, y: 1)
        rectangle.position = CGPoint(x: 0, y: verticalThresholdPoint)
        rectangle.zRotation = -(rotationAngle)
        rectangle.zPosition = 1
        
    
        let pb = SKPhysicsBody(rectangleOf: rectangle.size, center: CGPoint(x: rectangleWidth, y: -(rectangleHeigth / 2)))
        pb.isDynamic = false
        pb.categoryBitMask = 8
        pb.contactTestBitMask = 1
        pb.collisionBitMask = 0
//        pb.node?.physicsBody?.friction = 1
        rectangle.physicsBody = pb
        
        self.addChild(rectangle)
    }
    
     func moveBackground() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
    
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        rectangle.run(SKAction.repeatForever(moveAction))
    }
}



