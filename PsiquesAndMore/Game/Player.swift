import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var didJump: Bool = false
    var movements: Movements
}

enum Movements: Codable, CaseIterable {
    case upAndDown
    case rightAndLeft
}
