import Foundation

extension MatchManager {
    func sendReadyState(for game: Game, _ completion: @escaping () -> ()) {
        self.isHost = true
        
        print("sending ready state data")
        do {
            guard let data = try? JSONEncoder().encode(game) else { return }
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
