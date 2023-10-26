import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var didJump: Bool = false
    var life: Float = 100
}
