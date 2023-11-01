import SwiftUI
import SpriteKit
import GameKit


struct FirstView: View {
    @ObservedObject var matchManager: MatchManager
    
    let publi = NotificationCenter.default.publisher(for: .restartGameNotificationName)

    @State var showCredits : Bool = false
    @State var showInstructions: Bool = false
    
    var scene: SKScene {
        let scene = GameScene2(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        //scene.matchManager = matchManager
        //scene.match = matchManager.match
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            if true || matchManager.isGamePresented {
                VStack {
                    SpriteView(scene: scene).ignoresSafeArea().navigationBarBackButtonHidden(true)
                }
            } else {
                NavigationStack {
                    
                    // link para o jogo, com imagem, sem texto
                    VStack {
                        Button {
                           // matchManager.startMatchmaking()
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
                             matchManager.startMatchmaking()
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
    }
}
