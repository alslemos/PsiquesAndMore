import Foundation
import UIKit

struct Player: Codable {
    var controls: Controls
}

enum Controls: Codable, CaseIterable {
    case upAndLeft
    case downAndRight
}
