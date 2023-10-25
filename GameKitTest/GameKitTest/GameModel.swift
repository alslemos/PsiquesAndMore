//
//  GameModel.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import Foundation
import UIKit
import GameKit

struct GameModel: Codable {
    var players: [Player] = []
    var time: Int = 60
}

extension GameModel {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: data)
    }
}
