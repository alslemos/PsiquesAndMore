import SwiftUI


struct FirstView: View {

    let publi =  NotificationCenter.default.publisher(for: .restartGameNotificationName)
    
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return scene
    }
    
    @State var showDetails: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 13 / 255, green: 43 / 255, blue: 69 / 255)
            
            NavigationStack {
                
                VStack {
                    Button {
                        showDetails = true
                    } label: {
                        Image("playButton")
                    }
                }.onAppear{
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
            }.ignoresSafeArea()
             .onReceive(publi) { _ in
                showDetails.toggle()
            }
        }
    }
}
