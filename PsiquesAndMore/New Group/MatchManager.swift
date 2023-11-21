import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject, UINavigationControllerDelegate, GKLocalPlayerListener {
    @Published var authenticationState: PlayerAuthState = .authenticating
    @Published var match: GKMatch?
    @Published var isGamePresented: Bool = false
    @Published var isHost: Bool = false
    
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
        }
        
        GKAccessPoint.shared.isActive = true
        GKAccessPoint.shared.location = .bottomLeading
        
        print(GKAccessPoint.shared.isActive)
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
    
    func sendReadyState(_ completion: @escaping () -> ()) {
        self.isHost = true
        
        print("sending ready state data")
        do {
            guard let data = try? JSONEncoder().encode("ready") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send ready state data failed")
        }
    }
    
    func sendLobbyCreationData(_ completion: @escaping () -> ()) {
        print("sending lobby creation data")
        do {
            guard let data = try? JSONEncoder().encode("lobby") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send lobby creation data failed")
        }
    }
    
    func sendBackToInitialData(_ completion: @escaping () -> ()) {
        print("sending back to initial data")
        do {
            guard let data = try? JSONEncoder().encode("initial") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send back to initial data failed")
        }
    }
}
