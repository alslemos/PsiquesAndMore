import Foundation
import GameKit
import SwiftUI

//class GameCenterHelper: NSObject, GKLocalPlayerListener {
//    @ObservedObject var menuViewModel = MatchManager()
//    
//    private var currentVC: GKMatchmakerViewController?
//    
//    private let minPlayers: Int = 2
//    private let maxPlayers: Int = 3
//    private let inviteMessage = "Write your default invite message!"
//    
//    var isAuthenticated: Bool {
//        return GKLocalPlayer.local.isAuthenticated
//    }
//    
//    func authenticatePlayer() {
//        GKLocalPlayer.local.authenticateHandler = { gameCenterAuthViewController, error in
//            self.menuViewModel.didChangeAuthStatus(isAuthenticated: self.isAuthenticated)
//            
//            guard GKLocalPlayer.local.isAuthenticated else {
//                self.menuViewModel.presentMatchmaking(viewController: gameCenterAuthViewController)
//                return
//            }
//            
//            GKLocalPlayer.local.register(self)
//        }
//    }
//    
//    func presentMatchmaker(withInvite invite: GKInvite? = nil) {
//        guard GKLocalPlayer.local.isAuthenticated,
//              let vc = createMatchmaker(withInvite: invite) else {
//            return
//        }
//        
//        currentVC = vc
//        vc.matchmakerDelegate = self
//        menuViewModel.presentMatchmaking(viewController: vc)
//    }
//    
//    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
//        
//        //If there is an invite, create the matchmaker vc with it
//        if let invite = invite {
//            return GKMatchmakerViewController(invite: invite)
//        }
//        
//        return GKMatchmakerViewController(matchRequest: createRequest())
//    }
//    
//    private func createRequest() -> GKMatchRequest {
//        let request = GKMatchRequest()
//        request.minPlayers = minPlayers
//        request.maxPlayers = maxPlayers
//        request.inviteMessage = inviteMessage
//        
//        return request
//    }
//}
//
//extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
//    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
//        
//    }
//    
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
//        
//    }
//}
