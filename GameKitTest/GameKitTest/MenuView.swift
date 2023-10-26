//
//  MenuView.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 26/10/23.
//

import SwiftUI
import SpriteKit

struct MenuView: View {
    @ObservedObject var vm: MatchManager
    
    var scene: SKScene {
        let scene = GameScene()
        scene.vm = vm
        scene.match = vm.match
        scene.size = UIScreen.main.bounds.size
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        VStack {
            Button {
                vm.isGameViewPresented = true
            } label: {
                Text("Start game")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 100)
            .background(
                Capsule(style: .circular)
                    .fill(.blue)
            )
        }
        .fullScreenCover(isPresented: $vm.isGameViewPresented) {
            SpriteView(scene: scene)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    MenuView(vm: MatchManager())
}
