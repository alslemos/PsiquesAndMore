import Foundation
import SpriteKit

extension GameScene {
    func setupSquidControls() {
        setupUpperButton()
        setupLowerButton()
    }
    
    func setupUpperButton() {
        let node = SKSpriteNode(color: .cyan, size: CGSize(width: 60, height: 60))
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: viewFrame.maxX - 60, y: viewFrame.minY + 140)
        node.name = "upperButton"
        node.zPosition = 20
        
        self.addChild(node)
    }
    
    func setupLowerButton() {
        let node = SKSpriteNode(color: .cyan, size: CGSize(width: 60, height: 60))
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: viewFrame.maxX - 60, y: viewFrame.minY + 60)
        node.name = "lowerButton"
        node.zPosition = Layers.UIElement
        
        self.addChild(node)
    }
}
