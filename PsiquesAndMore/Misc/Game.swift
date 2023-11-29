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
    case snake
    case squid
    
    var name: String {
        switch self {
            case .hill:
                return "down the hill"
            case .snake:
                return "snake survival"
            case .squid:
                return "hopscotch"
        }
    }
    
    var image: Image {
        switch self {
            case .hill:
                return Image(.downTheHillCard)
            case .snake:
                return Image(.gamePlaceholder)
            case .squid:
                return Image(.squidCard)
        }
    }
    
    var isAvailable: Bool {
        switch self {
            case .hill:
                return true
            case .snake:
                return false
            case .squid:
                return true
        }
    }
}
