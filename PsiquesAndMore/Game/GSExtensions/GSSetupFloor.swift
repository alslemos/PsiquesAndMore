//
//  GSSetupFloor.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    
    func setupFloor(){
        var rectangleWidth: CGFloat = 0
        var rectangleHeigth: CGFloat = 0
        
        verticalThresholdPoint = (self.view?.frame.height)! * 0.58
        
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) +
                              ((self.view?.frame.width)! * (self.view?.frame.width)!))
        
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        
        rectangleHeigth = sin(rotationAngle) * (self.view?.frame.width)!

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!),
                                 size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
      
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0, y: 1)
        rectangle.position = CGPoint(x: 0, y: verticalThresholdPoint)
        rectangle.zRotation = -(rotationAngle)
        
        
//        let pb = SKPhysicsBody(texture: rectangle.texture!,
//                                       size: rectangle.texture!.size())
        let pb = SKPhysicsBody(rectangleOf: rectangle.size, center: CGPoint(x: rectangleWidth, y: -(rectangleHeigth / 2)))
        pb.isDynamic = false
        pb.node?.physicsBody?.friction = 0.0
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



