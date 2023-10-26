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

struct ContentView: View {
    @ObservedObject var vm: MatchManager

    var body: some View {
        ZStack {
            if !vm.isMenuViewPresented {
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
                MenuView(vm: vm)
            }
        }
        .onAppear {
            vm.authenticatePlayer()
        }
    }
}

#Preview {
    ContentView(vm: MatchManager())
}
