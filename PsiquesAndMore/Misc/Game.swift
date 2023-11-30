//
//  Game.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SwiftUI

enum Game: CaseIterable, Codable {
    case hill
    case squid
    case snake
    
    var name: String {
        switch self {
            case .hill:
                return "down the hill"
            case .squid:
                return "lava hopscotch"
            case .snake:
                return "snake survival"
        }
    }
    
    var image: Image {
        switch self {
            case .hill:
                return Image(.downTheHillCard)
            case .squid:
                return Image(.squidCard)
            case .snake:
                return Image(.snakeSurvival)
        }
    }
    
    var isAvailable: Bool {
        switch self {
            case .hill:
                return true
            case .squid:
                return true
            case .snake:
                return false
        }
    }
}
