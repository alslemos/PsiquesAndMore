import Foundation
import SpriteKit

struct Textures {
    static let avalancheTexture = SKTexture(imageNamed: "avalanche")
    static let rockTexture = SKTexture(imageNamed: "rock")
    static let rockPhysicsTexture = SKTexture(imageNamed: "rockPhysics")
    static let birdTexture = SKTexture(imageNamed: "bird")
    static let trunkTexture = SKTexture(imageNamed: "trunk")
    static let branchTexture = SKTexture(imageNamed: "branch")
    static let floorTexture = SKTexture(imageNamed: "floor")
    static let heartFillTexture = SKTexture(image: UIImage(systemName: "heart.fill") ?? UIImage())
    static let heartTexture = SKTexture(image: UIImage(systemName: "heart") ?? UIImage())
    static let lavaTexture = SKTexture(image: UIImage(named: "lavaTexture") ?? UIImage())
    static let groundTexture = SKTexture(image: UIImage(named: "ground") ?? UIImage())
}
