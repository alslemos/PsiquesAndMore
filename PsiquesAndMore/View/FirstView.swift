import SwiftUI
import SpriteKit
import GameKit


struct FirstView: View {
    @ObservedObject var matchManager: MatchManager
    
    // NotificationCenter for view display control
    
    let gameOverPublisher = NotificationCenter.default.publisher(for: .restartGameNotificationName)
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
    
    init(matchManager: ObservedObject<MatchManager>) {
        self._matchManager = matchManager
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.matchManager = matchManager.wrappedValue
        scene.match = matchManager.wrappedValue.match
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        self.scene = scene
    }
    
    var body: some View {
        ZStack {
            if matchManager.isGamePresented {
                VStack {
                    SpriteView(scene: scene, debugOptions: .showsPhysics).ignoresSafeArea().navigationBarBackButtonHidden(true)
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
                    scene.isContinueOrderGiven = true
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
                    scene.isPlayAgainOrderGiven = true
                }
            } else {
                scene.isGoToMenuOrderGiven = false
            }
            
            showGameOverView = false
            scene.isPaused = false
            scene.restartGame()
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
            
            matchManager.isGamePresented = false
        }
    }
}
