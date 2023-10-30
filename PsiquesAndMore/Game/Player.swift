import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var didMoveControl1: Bool = false
    var didMoveControl2: Bool = false
    var movements: Movements
}

enum Movements: Codable, CaseIterable {
    case upAndLeft
    case downAndRight
}
