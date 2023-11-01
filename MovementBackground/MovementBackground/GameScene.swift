//
//  GameScene.swift
//  MovementBackground
//
//  Created by Arthur Sobrosa on 31/10/23.
//

import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene {
    private var rectangle = SKSpriteNode()
    private var square = SKSpriteNode()
    
    // Don't forget to cancel this afterwards
    private var cancellables = Set<AnyCancellable>()
    
    var verticalThresholdPoint: CGFloat = 0
    var rectangleWidth: CGFloat = 0
    var rectangleHeigth: CGFloat = 0
    var rotationAngle: CGFloat = 0
    
    var squareYPosition: CGFloat = 0
    
    var backgroundSpeed: CGFloat! {
        didSet {
            rectangle.removeAllActions()
            moveSprite()
        }
    }
    
    var gameDuration: Int = 60
    
    override func didMove(to view: SKView) {
        verticalThresholdPoint = view.frame.height * 0.58
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) + (view.frame.width * view.frame.width))
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        rectangleHeigth = sin(rotationAngle) * view.frame.width

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!), size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1)
        rectangle.position = CGPoint(x: view.frame.width, y: 0)
        rectangle.zRotation = -(rotationAngle)

        squareYPosition = verticalThresholdPoint - (view.frame.midX * tan(rotationAngle))
        
        square = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        square.position = CGPoint(x: view.frame.midX, y: squareYPosition)
        square.zRotation = -(rotationAngle)
        
        addChild(rectangle)
        addChild(square)
        
        backgroundSpeed = 0
        
        createSubscriptions()
    }
    
    private func moveSprite() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
    
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        rectangle.run(SKAction.repeatForever(moveAction))
    }
    
    // MARK: - Combine functions
    private func createSubscriptions() {
        backgroundPositionUpdater()
        velocityUpdater()
        timerTracker()
    }
    
    private func backgroundPositionUpdater() {
        guard let view = self.view else { return }
        
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= 0 {
                    self.rectangle.position = CGPoint(x: view.frame.width, y: 0)
                }
            }.store(in: &cancellables)
    }
    
    private func velocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
    
    private func timerTracker() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                return count + 1
            }
            .sink { count in
                if count >= self.gameDuration {
                    print("time's up")
                    // perform game over
                }
            }.store(in: &cancellables)
    }
}
