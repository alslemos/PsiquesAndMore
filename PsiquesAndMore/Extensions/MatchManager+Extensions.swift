import Foundation
import GameKit

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
        viewController.dismiss(animated: false)
    }
}

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let actionString = try? JSONDecoder().decode(String.self, from: data) {
            if actionString == "ready" {
                print("ready state data received")
                
                NotificationCenter.default.post(name: .readyToPlayGameNotificationName, object: nil)
            }
            
            if actionString == "lobby" {
                print("lobby creation data received")
                
                NotificationCenter.default.post(name: .lobbyCreationNotificationName, object: nil)
            }
            
            if actionString == "initial" {
                print("back to initial data received")
                
                NotificationCenter.default.post(name: .backToInitialScreenNotificationName, object: nil)
            }
        }
    }
}
