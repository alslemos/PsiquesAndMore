//
//  Misc.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import Foundation

enum PlayerAuthState: String {
    case authenticating = "Logging in to game center..."
    case unauthenticated = "Please log in to Game Center to play."
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games!"
}
