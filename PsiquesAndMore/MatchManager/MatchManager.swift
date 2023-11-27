import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject, UINavigationControllerDelegate, GKLocalPlayerListener {
    @Published var authenticationState: PlayerAuthState = .authenticating
    @Published var match: GKMatch?
    @Published var isGamePresented: Bool = false
    @Published var isHost: Bool = false
    
    static let leaderBoardID = "firstLeaderboard"
    
    var localPlayer = GKLocalPlayer.local
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    private func presentMatchmaking(viewController: UIViewController?) {
        guard let vc = viewController else { return }
        rootViewController?.present(vc, animated: true)
        print("presenting matchmaking view controller...")
    }
    
    func startMatchmaking(witInvite invite: GKInvite? = nil) {
        guard localPlayer.isAuthenticated, let vc = createMatchmaker(withInvite: invite) else {
            return
        }
        
        vc.matchmakerDelegate = self
        presentMatchmaking(viewController: vc)
    }
    
    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
        //If there is an invite, create the matchmaker vc with it
        if let invite = invite {
            return GKMatchmakerViewController(invite: invite)
        }
        
        return GKMatchmakerViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.inviteMessage = "blablabla"
        
        return request
    }
    
    func startGame(newMatch: GKMatch) {
        print("starting game...")
        match = newMatch
        match?.delegate = self
        isGamePresented = true
    }
}
