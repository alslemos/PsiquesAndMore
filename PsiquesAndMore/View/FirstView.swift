import SwiftUI
import SpriteKit
import GameKit


struct FirstView: View {
    @ObservedObject var matchManager: MatchManager
    
    // NotificationCenter for view display control
    
    let publi = NotificationCenter.default.publisher(for: .restartGameNotificationName)
    let pauseGamePublisher = NotificationCenter.default.publisher(for: .pauseGameNotificationName)
    let continueGamePublisher = NotificationCenter.default.publisher(for: .continueGameNotificationName)
    let playAgainPublisher = NotificationCenter.default.publisher(for: .playAgainGameNotificationName)
    let goToMenuPublisher = NotificationCenter.default.publisher(for: .goToMenuGameNotificationName)
    
    // View display control variables
    
    @State var showCredits : Bool = false
    @State var showInstructions: Bool = false
    @State var showPauseGameView: Bool = false
    @State var showGameOverView: Bool = false
    
    var scene: GameScene
    var singleScene: SingleGameScene
    
    @State private var showSingleScene: Bool = false
    
    init(matchManager: ObservedObject<MatchManager>) {
        self._matchManager = matchManager
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.matchManager = matchManager.wrappedValue
        scene.match = matchManager.wrappedValue.match
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        self.scene = scene
        
        let singleScene = SingleGameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        singleScene.anchorPoint = CGPoint(x: 0, y: 0)
        singleScene.scaleMode = .fill
        self.singleScene = singleScene
    }
    
    var body: some View {
        ZStack {
            if matchManager.isGamePresented {
                VStack {
                    if showSingleScene {
                        SpriteView(scene: singleScene).ignoresSafeArea().navigationBarBackButtonHidden(true)
                    } else {
                        SpriteView(scene: scene, debugOptions: .showsPhysics).ignoresSafeArea().navigationBarBackButtonHidden(true)
                    }
                }
                
                if showPauseGameView {
                    PauseGameView()
                }
                
                if showGameOverView {
                    GameOverView()
                }
                
            } else {
                NavigationStack {
                    
                    // link para o jogo, com imagem, sem texto
                    VStack {
                        Button {
                            matchManager.startMatchmaking()
                        } label: {
                            Image("playButton")
                        }
                    }
                    .onAppear {
                        if matchManager.authenticationState != .authenticated {
                            matchManager.authenticatePlayer()
                        }
                    }
                    .onDisappear {
                        GKAccessPoint.shared.isActive = false
//                        matchManager.isGamePresented = false
                    }
                    
                    // link para o jogo, sem imagem só texto
                    VStack {
                         Button("Jogar") {
                             matchManager.isGamePresented = true
                             showSingleScene = true
                         }
                    }
                    
                    // link para as instrucoes
                    VStack {
                         Button("Instructions") {
                          showInstructions = true
                         }
                        }
                    .navigationDestination(isPresented:  $showInstructions) {
                        VStack {
                            InstructionsView().ignoresSafeArea().navigationBarBackButtonHidden(false)
                        }
                    }
                    
                    // link para as creditos
                    VStack {
                         Button("Credits") {
                          showCredits = true
                         }
                        }
                    .navigationDestination(isPresented: $showCredits) {
                        VStack {
                            CreditsView().ignoresSafeArea().navigationBarBackButtonHidden(false)
                        }
                    }
                    
                }.ignoresSafeArea()
            }
        }
        .onReceive(publi) { _ in
            matchManager.isGamePresented = false
       }
        
        .onReceive(pauseGamePublisher) { _ in
            if showSingleScene {
                singleScene.isPaused = true
                showPauseGameView = true
            } else {
                scene.isPaused = true
                showPauseGameView = true
            }
        }
        .onReceive(continueGamePublisher) { _ in
            if showSingleScene {
                singleScene.isPaused = false
                
                showPauseGameView = false
            } else {
                scene.isPaused = false
                
                if scene.isGamePaused {
                    scene.isGamePaused = false
                    scene.sendPausedStateData()
                }
                
                showPauseGameView = false
            }
        }
        .onReceive(playAgainPublisher) { _ in
            // restart game without going to menu
        }
        .onReceive(goToMenuPublisher) { _ in
            if showSingleScene {
                singleScene.virtualController?.disconnect()
                
                showPauseGameView = false
                singleScene.gameOver()
                matchManager.isGamePresented = false
            } else {
                scene.virtualController?.disconnect()
                
                // Check if both players know about the go to menu order
                // before sending data to remote player
                
                // In this case, just one of the players know about
                // the go to menu order
                if !scene.isGoToMenuOrderGiven {
                    scene.sendGoToMenuData()
                } else {
                    scene.isGoToMenuOrderGiven = false
                }
                
                showPauseGameView = false
                scene.gameOver()
                matchManager.isGamePresented = false
            }
        }
    }
}
