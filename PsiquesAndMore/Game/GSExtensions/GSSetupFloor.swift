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
        verticalThresholdPoint = (self.view?.frame.height)! * 0.58
        
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) +
                              ((self.view?.frame.width)! * (self.view?.frame.width)!))
        
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        
        rectangleHeigth = sin(rotationAngle) * (self.view?.frame.width)!

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!), 
                                 size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
      
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1)
        rectangle.position = CGPoint(x: (self.view?.frame.width)!, y: 0)
        rectangle.zRotation = -(rotationAngle)
        
        addChild(rectangle)
    }
}

// self.view?.frame.midX)!
