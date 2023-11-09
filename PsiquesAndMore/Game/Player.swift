import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var controls: Controls
    var numberOfLives: Int = 3
}

enum Controls: Codable, CaseIterable {
    case upAndLeft
    case downAndRight
}
