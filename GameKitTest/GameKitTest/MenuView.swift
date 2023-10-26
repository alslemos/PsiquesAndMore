//
//  ContentView.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import SwiftUI
import UIKit
import SpriteKit
import GameKit

struct MenuView: View {
    @ObservedObject var vm: MatchManager
    
    var scene: SKScene {
        let scene = GameScene()
        scene.match = vm.match
        scene.size = UIScreen.main.bounds.size
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            if !vm.isGameViewPresented {
                VStack {
                    Button {
                        vm.startMatchmaking()
                    } label: {
                        Text("Play")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    .disabled(vm.authenticatonState != .authenticated || vm.inGame)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 100)
                    .background(
                        Capsule(style: .circular)
                            .fill(vm.authenticatonState != .authenticated || vm.inGame ? .gray : .blue)
                    )
                    
                    Text(vm.authenticatonState.rawValue)
                        .foregroundColor(.white)
                }
            } else {
                SpriteView(scene: scene)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        .onAppear {
            vm.authenticatePlayer()
        }
    }
}

#Preview {
    MenuView(vm: MatchManager())
}
