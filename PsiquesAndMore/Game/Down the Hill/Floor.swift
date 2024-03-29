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
        
        character.zRotation = -(rotationAngle)
        
        rectangleHeigth = sin(rotationAngle) * (viewFrame.width)
        
        rectangle = SKSpriteNode(texture: Textures.floorTexture,
                                 size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
        
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0, y: 1)
        rectangle.position = CGPoint(x: 0, y: verticalThresholdPoint)
        rectangle.zRotation = -(rotationAngle)
        rectangle.zPosition = Layers.floor
        
        let pb = SKPhysicsBody(rectangleOf: rectangle.size, center: CGPoint(x: rectangleWidth, y: -(rectangleHeigth / 2) - 10))
        
        pb.isDynamic = false
        
        pb.categoryBitMask = DownTheHillPhysicsCategory.floorNode
        pb.contactTestBitMask = DownTheHillPhysicsCategory.characterNode
        pb.collisionBitMask = 0
        
        rectangle.physicsBody = pb
        
        self.addChild(rectangle)
    }
    
    func floorMovement() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
        
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * floorSpeed), dy: -(deltaY * floorSpeed)), duration: 1)
        
        rectangle.run(SKAction.repeatForever(moveAction))
    }
    
    // MARK: - Floor Subscription
    func createFloorPositionUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= -(self.viewFrame.width) {
                    self.rectangle.position = CGPoint(x: 0, y: self.verticalThresholdPoint)
                }
            }.store(in: &cancellables)
    }
    
    func createFloorVelocityUpdater() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .sink { _ in
                self.floorSpeed += 1
                
                if (self.movementDelay - 0.0625) >= 0.25 {
                    self.movementDelay -= 0.0625
                }
                
                if (self.movementImpulse + 10) <= 100 {
                    self.movementImpulse += 10
                }
            }.store(in: &cancellables)
    }
}



