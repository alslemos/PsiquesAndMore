import SwiftUI
import SpriteKit
import GameKit


struct FirstView: View {
    @State var showGame : Bool = false
    @State var showCredits : Bool = false
    @State var showInstructions: Bool = false

    let publi =  NotificationCenter.default.publisher(for: .restartGameNotificationName)
    
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return scene
    }
    
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                
                // link para o jogo, com imagem, sem texto
                VStack {
                    Button {
                        showGame = true
                    } label: {
                        Image("playButton")
                    }
                }
                .onAppear{
                    GKAccessPoint.shared.isActive = true
                }
                .onDisappear {
                    GKAccessPoint.shared.isActive = false
                    showGame = false
                }
                
                .navigationDestination(isPresented: $showGame) {
                    VStack {
                        SpriteView(scene: scene).ignoresSafeArea().navigationBarBackButtonHidden(true)
                    }
                }
                
                // link para o jogo, sem imagem só texto
                VStack {
                     Button("Jogar") {
                     showGame = true
                     }
                }
                .navigationDestination(isPresented: $showGame) {
                    VStack {
                        SpriteView(scene: scene).ignoresSafeArea().navigationBarBackButtonHidden(true)
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
             .onReceive(publi) { _ in
                showGame.toggle()
            }
        }
    }
}
