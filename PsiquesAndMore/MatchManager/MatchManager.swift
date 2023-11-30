import Foundation
import GameKit
import SwiftUI

@MainActor
class MatchManager: NSObject, ObservableObject, UINavigationControllerDelegate {
    @Published var authenticationState: AuthenticationState = .authenticating
    @Published var match: GKMatch?
    @Published var isGamePresented: Bool = false
    @Published var isHost: Bool = false
    @Published var restrictedAlert: Bool = false
    @Published var selectedGame: Game = .hill
    @Published var myTurn: Bool = false
    
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
    
    func startMatchmaking() {
        if localPlayer.isMultiplayerGamingRestricted {
            restrictedAlert = true
            
            return
        }
        
        guard localPlayer.isAuthenticated, let vc = createMatchmaker() else {
            return
        }
        
        vc.matchmakerDelegate = self
        presentMatchmaking(viewController: vc)
    }
    
    private func createMatchmaker() -> GKMatchmakerViewController? {
        return GKMatchmakerViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        return request
    }
    
    func startGame(newMatch: GKMatch) {
        print("starting game...")
        match = newMatch
        match?.delegate = self
        isGamePresented = true
    }
}
