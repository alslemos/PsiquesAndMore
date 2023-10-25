import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject, UINavigationControllerDelegate, GKLocalPlayerListener {
    @Published var authenticatonState: PlayerAuthState = .authenticating
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    
    @Published var isGameViewPresented = false {
        didSet {
            print("value of 'isGameViewPresented' changed")
        }
    }
    
    private var gameModel: GameModel?
    
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { [self] viewController, error in
            if let viewController = viewController {
                print("presenting authentication view controller...")
                self.rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = error {
                self.authenticatonState = .error
                print(error.localizedDescription)
                
                return
            }
            
            if self.localPlayer.isAuthenticated {
                if self.localPlayer.isMultiplayerGamingRestricted {
                    self.authenticatonState = .restricted
                } else {
                    print("player authenticated...")
                    self.authenticatonState = .authenticated
                }
            } else {
                self.authenticatonState = .unauthenticated
            }
        }
    }
    
    func presentMatchmaking(viewController: UIViewController?) {
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
        
//        let request = GKMatchRequest()
//        request.minPlayers = 2
//        request.maxPlayers = 2
//        
//        let matchmakingViewController = GKMatchmakerViewController(matchRequest: request)
//        matchmakingViewController?.delegate = self
//        
//        rootViewController?.present(matchmakingViewController ?? GKMatchmakerViewController(), animated: true)
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
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        
        print("toggle na variavel para acionar sheet")
        isGameViewPresented = true
    }
}

extension MatchManager: GKMatchmakerViewControllerDelegate {
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        startGame(newMatch: match)
        print("partida encontrada")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
}

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = GameModel.decode(data: data) else { return }
        gameModel = model
    }
}
