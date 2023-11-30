import Foundation
import GameKit

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let actionString = try? JSONDecoder().decode(String.self, from: data) {
            if actionString == "lobby" {
                print("lobby creation data received")
                
                NotificationCenter.default.post(name: .lobbyCreationNotificationName, object: nil)
            }
            
            if actionString == "initial" {
                print("back to initial data received")
                
                NotificationCenter.default.post(name: .backToInitialScreenNotificationName, object: nil)
            }
        }
        
        if let game = try? JSONDecoder().decode(Game.self, from: data) {
            print("ready state data received")
            
            selectedGame = game
            
            NotificationCenter.default.post(name: .readyToPlayGameNotificationName, object: nil)
        }
    }
}
