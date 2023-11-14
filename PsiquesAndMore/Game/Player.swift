import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var controls: Controls
}

enum Controls: Codable, CaseIterable {
    case upAndLeft
    case downAndRight
}
