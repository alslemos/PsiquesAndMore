//
//  PickLevelView.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import SwiftUI
import SpriteKit
import GameKit


struct PickLevelView: View {
    @ObservedObject var matchManager: MatchManager
    
    // NotificationCenter for view display control
    let gameOverPublisher = NotificationCenter.default.publisher(for: .gameOverGameNotificationName)
    let pauseGamePublisher = NotificationCenter.default.publisher(for: .pauseGameNotificationName)
    let continueGamePublisher = NotificationCenter.default.publisher(for: .continueGameNotificationName)
    let playAgainPublisher = NotificationCenter.default.publisher(for: .playAgainGameNotificationName)
    let goToMenuPublisher = NotificationCenter.default.publisher(for: .goToMenuGameNotificationName)
    let readyPublisher = NotificationCenter.default.publisher(for: .readyToPlayGameNotificationName)
    let lobbyCreationPublisher = NotificationCenter.default.publisher(for: .lobbyCreationNotificationName)
    
    @State var showPauseGameView: Bool = false
    @State var showGameOverView: Bool = false
    @State var showGameScene: Bool = false
    
    @State private var index = 0
    
    var scene: GameScene
    
    init(matchManager: ObservedObject<MatchManager>) {
        self._matchManager = matchManager
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.matchManager = matchManager.wrappedValue
        scene.match = matchManager.wrappedValue.match
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        self.scene = scene
    }
    
    var fundo = Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
    var clique = Color(red: 253 / 255, green: 169 / 255, blue: 101 / 255)
    var semclique = Color(red: 255 / 255, green: 236 / 255, blue: 215 / 255)
    
    
    var body: some View {
        ZStack {
            if showGameScene {
                VStack {
                    SpriteView(scene: scene, debugOptions: .showsPhysics).ignoresSafeArea().navigationBarBackButtonHidden(true)
                }
                .onAppear {
                    showPauseGameView = false
                    showGameOverView = false
                }
                
                if showPauseGameView {
                    PauseGameView()
                }
                
                if showGameOverView {
                    GameOverView()
                }
            } else {
                ZStack {
                    Color(red: 33 / 255, green: 60 / 255, blue: 85 / 255)
                    
                    
                    VStack() {
                        
                        Spacer()
                        
                        Text("Pick an adventure to explore!")
                            .font(.custom("LuckiestGuy-Regular", size: 24)) //LuckiestGuy-Regular
                            .foregroundColor(clique)
                            .padding(.all)
                        
                        HStack {
                            //                TabView(selection: $index) {
                            ForEach((0..<3), id: \.self) { index in
                                CardView(matchManager: matchManager, showGameScene: $showGameScene)
                                //             eu l       }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                        }
                     
                        Spacer()
                        
                    }
                
                }.ignoresSafeArea()
            }
        }
        .onReceive(lobbyCreationPublisher) { _ in
            matchManager.isGamePresented = false
        }
        .onReceive(readyPublisher) { _ in
            print("inside notification handler")
            
            showGameScene = true
        }
        .onReceive(gameOverPublisher) { _ in
            showGameOverView = true
            scene.isPaused = true
        }
        .onReceive(pauseGamePublisher) { _ in
            scene.isPaused = true
            showPauseGameView = true
        }
        .onReceive(continueGamePublisher) { _ in
            if !scene.isContinueOrderGiven {
                scene.sendNotificationData(.continueGame) {
                    print("sending continue game data")
                }
            } else {
                scene.isContinueOrderGiven = false
            }
            
            scene.isPaused = false
            self.showPauseGameView = false
        }
        .onReceive(playAgainPublisher) { _ in
            if !scene.isPlayAgainOrderGiven {
                scene.sendNotificationData(.playAgain) {
                    print("sending play again data")
                }
            } else {
                scene.isPlayAgainOrderGiven = false
            }
            
            showGameOverView = false
            scene.isPaused = false
            
            scene.restartGame()
            scene.timerLabel.text = ""
        }
        .onReceive(goToMenuPublisher) { _ in
            scene.virtualController?.disconnect()
            
            if !scene.isGoToMenuOrderGiven {
                scene.sendNotificationData(.goToMenu) {
                    scene.isGoToMenuOrderGiven = true
                }
            } else {
                scene.isGoToMenuOrderGiven = false
            }
            
            showPauseGameView = false
            
            scene.gameOver {
                print("bye bye")
            }
            
            showGameScene = false
            
            guard let match = scene.match else { return }
            
            matchManager.startGame(newMatch: match)
        }
    }
}
