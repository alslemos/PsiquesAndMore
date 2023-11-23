//
//  Textures.swift
//  PsiquesAndMore
//
//  Created by Gustavo Zahorcsak Matias Silvano on 22/11/23.
//

import Foundation
import SpriteKit



enum Textures {

    static let avalancheTexture = SKTexture(imageNamed: "avalanche")
    static let rockTexture = SKTexture(imageNamed: "rock")
    static let rockPhysicsTexture = SKTexture(imageNamed: "rockPhysics")
    static let birdTexture = SKTexture(imageNamed: "bird")
    static let treeTexture = SKTexture(imageNamed: "fullTree")
    static let floorTexture = SKTexture(imageNamed: "floor")
    
    case avalanche
    case rock
    case rockPhysics
    case bird
    case tree
    case floor
    
    func getTexture(_ texture: Textures) -> SKTexture {
        switch texture {
            case .avalanche:
                return Textures.avalancheTexture
            case .rock:
                return Textures.rockTexture
            case .rockPhysics:
                return Textures.rockPhysicsTexture
            case .bird:
                return Textures.birdTexture
            case .tree:
                return Textures.treeTexture
            case .floor:
                return Textures.floorTexture
        }
    }
}
