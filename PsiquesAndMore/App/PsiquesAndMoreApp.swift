import SwiftUI
import GameKit

@main
struct PsiquesAndMoreApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView().ignoresSafeArea()
        }
    }
}

func iniciaGameKit(){
    GKLocalPlayer.local.authenticateHandler = {
        viewController, error in
        
        if let viewController = viewController {
            print(" player can sign in")
            // present the view controller so the player can sign in
            return
        }
        
        if error != nil {
            // player could not be authenticated
            // disable game center in the game
            print("player could not be authenticated")
            return
        }
    }
    
    GKAccessPoint.shared.isActive = true
    GKAccessPoint.shared.location = .bottomLeading
    
    print(GKAccessPoint.shared.isActive)
}

