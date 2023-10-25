//
//  ContentView.swift
//  GameKitTest
//
//  Created by Arthur Sobrosa on 25/10/23.
//

import SwiftUI
import UIKit

struct MenuView: View {
    @ObservedObject var vm: MatchManager
//    @State var isGameViewPresented = false
    
    var body: some View {
        NavigationStack {
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
            }
            .padding()
        }
        .onAppear {
            vm.authenticatePlayer()
        }
        .sheet(isPresented: $vm.isGameViewPresented) {
            GameView(matchManager: vm)
        }
        .onChange(of: vm.isGameViewPresented) { oldValue, newValue in
            print("mudou o valor do bgl")
        }
    }
}

#Preview {
    MenuView(vm: MatchManager())
}
