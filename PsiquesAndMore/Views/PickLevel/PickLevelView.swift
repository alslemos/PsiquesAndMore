//
//  PickLevelView.swift
//  RememberingViews
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import SwiftUI
import SpriteKit
import GameKit

class GameSceneBox: ObservableObject {
    @Published var gameScene: GameScene {
        willSet {
            gameScene.clean()
        }
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
}

struct PickLevelView: View {
    @ObservedObject var matchManager: MatchManager
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // NotificationCenter for view display control
    let gameOverPublisher = NotificationCenter.default.publisher(for: .gameOverGameNotificationName)
    let pauseGamePublisher = NotificationCenter.default.publisher(for: .pauseGameNotificationName)
    let continueGamePublisher = NotificationCenter.default.publisher(for: .continueGameNotificationName)
    let playAgainPublisher = NotificationCenter.default.publisher(for: .playAgainGameNotificationName)
    let goToMenuPublisher = NotificationCenter.default.publisher(for: .goToMenuGameNotificationName)
    let readyPublisher = NotificationCenter.default.publisher(for: .readyToPlayGameNotificationName)
    let lobbyCreationPublisher = NotificationCenter.default.publisher(for: .lobbyCreationNotificationName)
    let loadingGamePublisher = NotificationCenter.default.publisher(for: .loadingGameNotificationName)
    let backToInitialScreenPublisher = NotificationCenter.default.publisher(for: .backToInitialScreenNotificationName)
    
    let yourTurnPublisher = NotificationCenter.default.publisher(for: .yourTurnNotificationName)
    let youWinPublisher = NotificationCenter.default.publisher(for: .youWinNotificationName)
    
    @State var showPauseGameView: Bool = false
    @State var showGameOverView: Bool = false
    @State var showLoadingGameView: Bool = false
    @State var showYourTurnView: Bool = false
    @State var showYouWinView: Bool = false
    
    @State var showGameScene: Bool = false
    
    @State private var index = 0
    
    @ObservedObject var gameSceneBox: GameSceneBox
    @State private var refreshToggle: Bool = false
    
    @State var backToInitialScreen: Bool = false
    
    init(matchManager: ObservedObject<MatchManager>) {
        self._matchManager = matchManager
        
        let gameScene = Self.createGameScene(withMatchManager: matchManager.wrappedValue)
        gameSceneBox = GameSceneBox(gameScene: gameScene)
    }
    
    private static func createGameScene(withMatchManager matchManager: MatchManager) -> GameScene {
        print("creating new scene")
        
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.matchManager = matchManager
        scene.match = matchManager.match
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        scene.isHost = matchManager.isHost
        scene.isItMyTurn = matchManager.myTurn
        
        return scene
    }
    
    let cards: [Game] = Game.allCases
    
    var body: some View {
        ZStack {
            if showGameScene {
                let _ = Self._printChanges()
                VStack {
                    SpriteView(scene: $gameSceneBox.gameScene.wrappedValue)
                        .id(refreshToggle)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                }
                .onAppear {
                    showPauseGameView = false
                    showGameOverView = false
                }
                
                if showYouWinView {
                    YouWinView()
                }
                
                if showYourTurnView {
                    if matchManager.myTurn {
                        YourTurnView(myTurn: true)
                    } else {
                        YourTurnView(myTurn: false)
                    }
                }
                
                if showPauseGameView {
                    PauseGameView()
                }
                
                if showGameOverView {
                    GameOverView(matchManager: matchManager)
                }
                
                if showLoadingGameView {
                    LoadingGameView()
                }
                
            } else {
                ZStack {
                    Color(.blueBlackground)
                    
                    VStack {
                        Text("Pick an adventure to explore!")
                            .font(.custom("LuckiestGuy-Regular", size: 24))
                            .foregroundColor(Color(.colorClickable))
                            .padding(.all)
                        
                        Spacer()
                        
                        HStack {
                            ForEach(cards, id: \.self) { card in
                                CardView(matchManager: matchManager, showGameScene: $showGameScene, showLoadingGameView: $showLoadingGameView, game: card)
                            }
                        }
                     
                        Spacer()
                    }
                    .padding(.top)
                }
                .ignoresSafeArea()
            }
        }
        .onReceive(youWinPublisher) { _ in
            showYouWinView = true
        }
        .onReceive(yourTurnPublisher) { _ in
            showYourTurnView.toggle()
        }
        .onReceive(lobbyCreationPublisher) { _ in
            matchManager.isGamePresented = false
        }
        .onReceive(readyPublisher) { _ in
            showGameScene = true
            showLoadingGameView = true
        }
        .onReceive(gameOverPublisher) { _ in
            showYourTurnView = false
            
            showYouWinView = false
            
            $gameSceneBox.gameScene.wrappedValue.removeCommands()
            
            if matchManager.selectedGame == .hill {
                $gameSceneBox.gameScene.wrappedValue.sendResults()
            }
            
            $gameSceneBox.gameScene.wrappedValue.isPaused = true
            
            showGameOverView = true
        }
        .onReceive(pauseGamePublisher) { _ in
            $gameSceneBox.gameScene.wrappedValue.isPaused = true
            
            showPauseGameView = true
        }
        .onReceive(continueGamePublisher) { _ in
            if !$gameSceneBox.gameScene.wrappedValue.isContinueOrderGiven {
                $gameSceneBox.gameScene.wrappedValue.sendNotificationData(.continueGame)
            } else {
                $gameSceneBox.gameScene.wrappedValue.isContinueOrderGiven = false
            }
            
            $gameSceneBox.gameScene.wrappedValue.isPaused = false
            
            self.showPauseGameView = false
        }
        .onReceive(playAgainPublisher) { _ in
            if !$gameSceneBox.gameScene.wrappedValue.isPlayAgainOrderGiven {
                $gameSceneBox.gameScene.wrappedValue.sendNotificationData(.playAgain)
                matchManager.isHost = true
            } else {
                $gameSceneBox.gameScene.wrappedValue.isPlayAgainOrderGiven = false
                matchManager.isHost = false
            }
            
            gameSceneBox.gameScene = Self.createGameScene(withMatchManager: matchManager)
            
            showGameOverView = false
            
            refreshToggle.toggle()
            
            showLoadingGameView = true
            
            showPauseGameView = false
        }
        .onReceive(goToMenuPublisher) { _ in
            showYouWinView = false
            
            if !$gameSceneBox.gameScene.wrappedValue.isGoToMenuOrderGiven {
                $gameSceneBox.gameScene.wrappedValue.sendNotificationData(.goToMenu)
                $gameSceneBox.gameScene.wrappedValue.isGoToMenuOrderGiven = true
            } else {
                $gameSceneBox.gameScene.wrappedValue.isGoToMenuOrderGiven = false
            }
            
            $gameSceneBox.gameScene.wrappedValue.removeCommands()
            
            $gameSceneBox.gameScene.wrappedValue.clean()
            
            guard let match = $gameSceneBox.gameScene.wrappedValue.match else { return }
            
            matchManager.startGame(newMatch: match)
            
            matchManager.isHost = false
            
            showPauseGameView = false
            
            showGameScene = false
            
            showYourTurnView = false
        }
        .onReceive(loadingGamePublisher) { _ in
            self.showLoadingGameView = false
        }
        .onReceive(backToInitialScreenPublisher) { _ in
            backToInitialScreen.toggle()
        }
        .navigationBarItems(leading: showGameScene ?
            Button {
                //
            } label: {
                Image(systemName: "apple.logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(.colorClickable))
                    .opacity(0)
            }
            .padding(.top, 35)
                            
            :
                            
            Button {
                matchManager.sendBackToInitialData()
            
                backToInitialScreen.toggle()
            
                $gameSceneBox.gameScene.wrappedValue.clean()
            
                $gameSceneBox.gameScene.wrappedValue.match?.disconnect()
                
                matchManager.match?.disconnect()
            } label: {
                Image(systemName: "arrowshape.turn.up.backward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(.colorClickable))
                    .opacity(1)
            }
            .padding(.top, 35)
        )
        .onChange(of: backToInitialScreen) { _ in
            self.matchManager.isGamePresented = false
        }
    }
}
