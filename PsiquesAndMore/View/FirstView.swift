import SwiftUI
import SpriteKit
import GameKit


struct FirstView: View {

    let publi =  NotificationCenter.default.publisher(for: .restartGameNotificationName)
    
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return scene
    }
    
    @State var showDetails: Bool = false
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                
                // link para o jogo, com imagem, sem texto
                VStack {
                    Button {
                        showDetails = true
                    } label: {
                        Image("playButton")
                    }
                }
                .onAppear{
                    GKAccessPoint.shared.isActive = true
                }
                .onDisappear {
                    GKAccessPoint.shared.isActive = false
                }
                
                .navigationDestination(isPresented: $showDetails) {
                    VStack {
                        SpriteView(scene: scene).ignoresSafeArea().navigationBarBackButtonHidden(true)
                    }
                }
                
                // link para o jogo, sem imagem só texto
//                VStack {
//                     Button("Jogar") {
//                      showDetails = false
//                     }
//                    }
//                .navigationDestination(isPresented: $showDetails) {
//                    VStack {
//                        SpriteView(scene: scene).ignoresSafeArea().navigationBarBackButtonHidden(true)
//                    }
//                }
                
                // link para as instrucoes
                VStack {
                     Button("Instructions") {
                      showDetails = true
                     }
                    }
                .navigationDestination(isPresented: $showDetails) {
                    VStack {
                        InstructionsView().ignoresSafeArea().navigationBarBackButtonHidden(false)
                    }
                }
                
                // link para as creditos
                VStack {
                     Button("Credits") {
                      showDetails = true
                     }
                    }
                .navigationDestination(isPresented: $showDetails) {
                    VStack {
                        CreditsView().ignoresSafeArea().navigationBarBackButtonHidden(false)
                    }
                }
                
                
            }.ignoresSafeArea()
             .onReceive(publi) { _ in
                showDetails.toggle()
            }
        }
    }
}
