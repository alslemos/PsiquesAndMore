import Foundation
import SpriteKit

extension GameScene {
    func moveSprite(_ movement: Movement) {
        if !self.isPaused {
            switch movement {
                case .up:
                    self.isPlayerMoving = true
                    
                    let deltaX = isRockFalling ? 0 : Int(movementImpulse)
                    let deltaY = Int(movementImpulse * 0.9)
                    
                    self.square.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
                case .down:
                    updateAssetSeAbaixando()
                    
                    self.isPlayerMoving = true
                    
                    self.littleSpriteBody()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + movementDelay) {
                        self.isPlayerMoving = false
                        
                        self.normalSpriteBody()
                        
                        self.updateAsset()
                    }
                case .right:
                    self.isPlayerMoving = true
                    
                    let deltaX = Int(movementImpulse)
                    let deltaY = 0
                    
                    self.square.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
                case .left:
                    self.isPlayerMoving = true
                    
                    let deltaX = -Int(movementImpulse * 0.8)
                    let deltaY = 0
                    
                    self.square.physicsBody?.applyImpulse(CGVector(dx: deltaX, dy: deltaY))
            }
            
            if movement != .down {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.isPlayerMoving = false
                    
                    self.updateAsset()
                }
            }
        }
    }
    
    func littleSpriteBody() {
        square.size = CGSize(width: 60, height: 30)
        
        let pb = SKPhysicsBody(rectangleOf: square.size, center: CGPoint(x: square.size.width / 2, y: square.frame.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = PhysicsCategory.characterNode
        pb.contactTestBitMask = PhysicsCategory.obstacleNode
        pb.collisionBitMask = PhysicsCategory.floorNode + PhysicsCategory.limitNode
        
        square.physicsBody = pb
    }
    
    func normalSpriteBody() {
        square.size = CGSize(width: 60, height: 60)
        
        let pb = SKPhysicsBody(rectangleOf: self.square.size, center: CGPoint(x: self.square.size.width / 2, y: self.square.size.height / 2))
        
        pb.allowsRotation = false
        pb.isDynamic = true
        pb.affectedByGravity = true
        
        pb.categoryBitMask = PhysicsCategory.characterNode
        pb.contactTestBitMask = PhysicsCategory.obstacleNode
        pb.collisionBitMask = PhysicsCategory.floorNode + PhysicsCategory.limitNode
        
        self.square.physicsBody = pb
    }
}

enum Movement: Codable {
    case up
    case down
    case left
    case right
}
