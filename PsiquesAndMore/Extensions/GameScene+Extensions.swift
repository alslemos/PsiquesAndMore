
import Foundation


extension GameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // First guard let checks if data received is the controls or the gameModel
        guard let controls = try? JSONDecoder().decode(Movements.self, from: data) else {
            // If data is not the controls, then try decoding a gameModel
            guard let model = GameModel.decode(data: data) else { return }
            gameModel = model
            return
        }
        
        // If data is the controls, then update player's controls
        guard let localIndex = localPlayerIndex else { return }
        gameModel.players[localIndex].movements = controls
        self.triggerCommands()
    }
}
