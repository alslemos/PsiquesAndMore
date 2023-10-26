//
//  GameKitTestApp.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import SwiftUI

@main
struct GameKitTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: MatchManager())
        }
    }
}
