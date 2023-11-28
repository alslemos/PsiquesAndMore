import Foundation
import GameKit

enum PlayerAuthState: String {
    case authenticating = "Logging in to game center..."
    case unauthenticated = "Please log in to Game Center to play."
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games!"
}

extension MatchManager {
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { [self] viewController, error in
            if let viewController = viewController {
                self.rootViewController?.present(viewController, animated: true) { }
                return
            }
            
            if let error = error {
                self.authenticationState = .error
                print(error.localizedDescription)
                
                return
            }
            
            if self.localPlayer.isAuthenticated {
                if self.localPlayer.isMultiplayerGamingRestricted {
                    self.authenticationState = .restricted
                } else {
                    print("player authenticated...")
                    self.authenticationState = .authenticated
                }
            } else {
                self.authenticationState = .unauthenticated
            }
            
            localPlayer.register(self)
            
            GKAccessPoint.shared.isActive = true
            GKAccessPoint.shared.location = .bottomLeading
            GKAccessPoint.shared.showHighlights = true
            
            print(GKAccessPoint.shared.isActive)
        }
    }
}
