//
//  GSSetupFloor.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 03/11/23.
//

import Foundation

extension GameScene {
    func setupFloor(){
        
    
    
    self.verticalThresholdPoint = view.frame.height * 0.58
    self.rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) + (view.frame.width * view.frame.width))
    self.rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
    rectangleHeigth = sin(rotationAngle) * view.frame.width

    self.rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!), size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
    rectangle.name = "floor"
    rectangle.anchorPoint = CGPoint(x: 0.5, y: 1)
    rectangle.position = CGPoint(x: view.frame.width, y: 0)
    rectangle.zRotation = -(rotationAngle)
    
    self.addChild(rectangle)
        
    }
        
}
