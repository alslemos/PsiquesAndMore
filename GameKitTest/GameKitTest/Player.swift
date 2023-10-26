//
//  Player.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import Foundation
import UIKit

struct Player: Codable {
    var displayName: String
    var didJump: Bool = false
    var life: Float = 100
}
