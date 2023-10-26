import SwiftUI
import GameKit
import SpriteKit
import Combine

class GameScene: SKScene {
    private var square = SKSpriteNode()
    private var label = SKLabelNode()
    private var timerLabel = SKLabelNode()
    
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    var gameModel: GameModel! {
        didSet {
            updateUI()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        match?.delegate = self
        
        savePlayers()
        
        square = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        square.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        label.position = CGPoint(x: view.frame.midX, y: view.frame.maxY - 100)
        label.fontColor = .white
        label.numberOfLines = 2
        label.fontSize = 20
        
        timerLabel.position = CGPoint(x: label.position.x, y: label.position.y - 50)
        timerLabel.fontColor = .white
        timerLabel.numberOfLines = 1
        timerLabel.fontSize = 20
        
        addChild(square)
        addChild(label)
        addChild(timerLabel)
        
        startTimer()
        setUpTapGestureRecognizer()
    }
    
    private func startTimer() {
        let timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        
        timer
            .scan(0, { count, _ in
                return count + 1
            })
            .sink { completion in
                print("data stream completion \(completion)")
            } receiveValue: { timeStamp in
                self.timerLabel.text = "\(timeStamp)"
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.gameOver()
        }
    }
    
    private func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
    }
    
    private func moveSprite() {
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.square.run(.move(to: CGPoint(x: self.square.position.x, y: self.square.position.y - 50), duration: 0.2))
        }
    }
    
    private func setUpTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        self.view?.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            guard let index = localPlayerIndex else {
                print("found index nil")
                return
            }
            
            self.gameModel.players[index].didJump = true
            self.sendData()
        }
    }
    
    private func savePlayers() {
        guard let remotePlayerName = match?.players.first?.displayName else { return }
        
        let localPlayer = Player(displayName: GKLocalPlayer.local.displayName)
        let remotePlayer = Player(displayName: remotePlayerName)
        
        var players = [localPlayer, remotePlayer]
        players.sort { (localPlayer, remotePlayer) -> Bool in
            localPlayer.displayName < remotePlayer.displayName
        }
        
        self.localPlayerIndex = players.firstIndex { $0.displayName == localPlayer.displayName }
        self.remotePlayerIndex = players.firstIndex { $0.displayName == remotePlayer.displayName }
        
        self.gameModel.players = players
        
        sendData()
    }
    
    private func updateUI() {
        guard self.gameModel.players.count >= 2 else { return }
        
        guard let index = remotePlayerIndex else {
            print("found remote player index nil")
            return
        }
        
        if gameModel.players[index].didJump {
            gameModel.players[index].didJump = false
            sendData()
            moveSprite()
        }
        
        label.text = "[\(self.gameModel.players[0].displayName): \(self.gameModel.players[0].didJump), \(self.gameModel.players[1].displayName): \(self.gameModel.players[1].didJump)]"
    }
    
    private func sendData() {
        guard let match = match else { return }
        
        do {
            guard let data = self.gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }
}

extension GameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = GameModel.decode(data: data) else { return }
        gameModel = model
    }
}
