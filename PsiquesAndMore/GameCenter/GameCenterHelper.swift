

import Foundation
import GameKit


class GameKitHelper: NSObject {
    static let leaderBoardID = "firstLeaderboard"
    
    // Shared GameKit Helper
    var authenticationViewController: UIViewController?
    
    static let shared: GameKitHelper = { let instance = GameKitHelper()
        return instance
    }()
    
    
    
    
    func authenticateLocalPlayer() { // Prepare for new controller
        
        authenticationViewController = nil // Authenticate local player
        
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {  // Present the view controller so the player can sign in
                self.authenticationViewController = viewController;
                NotificationCenter.default.post(
                    name: .presentAuthenticationViewController,
                    object: self)
                return
            }
            
            if error != nil {
                // Player could not be authenticated
                // Disable Game Center in the game
                return
            }
            
            // Player was successfully authenticated
            // Check if there are any player restrictions before starting the game
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content
            }
            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features
            }
            if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                // Disable in game communication UI
            }
            // Place the access point in the upper-right corner
            
            GKAccessPoint.shared.isActive = true
            GKAccessPoint.shared.location = .bottomLeading
            GKAccessPoint.shared.showHighlights = true
            
        }
    }
    
    func reportScore(score: Int, forLeaderboardID leaderboardID: String, errorHandler: ((Error?)->Void)? = nil) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        
        if #available(iOS 14, *) {
            GKLeaderboard.submitScore(score, context: 0,
                                      player: GKLocalPlayer.local,
                                      leaderboardIDs: [leaderboardID],
                                      completionHandler: errorHandler ?? { error in print("error: \(String(describing: error))") })
        }
        else {
            let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
            gkScore.value = Int64(score)
            GKScore.report([gkScore], withCompletionHandler: errorHandler)
        }
    }
    
    func reportAchievements(
            achievements: [GKAchievement],
            errorHandler: ((Error?)->Void)? = nil) {
                
        guard GKLocalPlayer.local.isAuthenticated else { return }
        
        GKAchievement.report(achievements, withCompletionHandler: errorHandler)  //  still need to call this method.
    }
    
    
}

extension Notification.Name {
    static let presentAuthenticationViewController =
    Notification.Name("presentAuthenticationViewController") }
