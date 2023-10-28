import SwiftUI
import GameKit
import SpriteKit
import Combine

class GameScene: SKScene {
    private var square = SKSpriteNode()
    private var timerLabel = SKLabelNode()
    
    private var control1 = SKSpriteNode()
    private var control2 = SKSpriteNode()
    
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    private var gameModel: GameModel! {
        didSet {
            updateUI()
        }
    }
    
    var isControlSet: Bool = false
    
    var controls: [String]! {
        didSet {
            updateUI()
        }
    }
    
    var areControlNodesSet: Bool = false
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        match?.delegate = self
        
        savePlayers()
        
        square = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        square.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        timerLabel.position = CGPoint(x: view.frame.midX, y: view.frame.maxY - 150)
        timerLabel.fontColor = .white
        timerLabel.numberOfLines = 1
        timerLabel.fontSize = 20
        
        addChild(square)
        addChild(timerLabel)
        
//        startTimer()
//        setUpTapGestureRecognizer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                if node == control1 {
                    guard let localIndex = localPlayerIndex else { return }
                    
                    self.gameModel.players[localIndex].didMoveControl1 = true
                    
                    self.sendData {
                        self.checkMovement(for: 1, with: localIndex)
                    }
                }
                
                if node == control2 {
                    guard let localIndex = localPlayerIndex else { return }
                    
                    self.gameModel.players[localIndex].didMoveControl2 = true
                    
                    self.sendData {
                        self.checkMovement(for: 2, with: localIndex)
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        let timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        
        let subscription = timer
            .scan(0, { count, _ in
                return count + 1
            })
            .sink { completion in
                print("data stream completion \(completion)")
            } receiveValue: { timeStamp in
                self.timerLabel.text = "\(timeStamp)"
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.gameOver()
            subscription.cancel()
        }
    }
    
    private func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        timerLabel.removeFromParent()
        control1.removeFromParent()
        control2.removeFromParent()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
    }
    
    private func moveUp() {
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.square.run(.move(to: CGPoint(x: self.square.position.x, y: self.square.position.y - 50), duration: 0.2))
        }
    }
    
    private func moveDown() {
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.square.run(.move(to: CGPoint(x: self.square.position.x, y: self.square.position.y + 50), duration: 0.2))
        }
    }
    
    private func moveRight() {
        square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.square.run(.move(to: CGPoint(x: self.square.position.x - 50, y: self.square.position.y), duration: 0.2))
        }
    }
    
    private func moveLeft() {
        square.run(.move(to: CGPoint(x: square.position.x - 50, y: square.position.y), duration: 0.2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.square.run(.move(to: CGPoint(x: self.square.position.x + 50, y: self.square.position.y), duration: 0.2))
        }
    }
    
    private func checkMovement(for control: Int, with playerIndex: Int) {
        if self.gameModel.players[playerIndex].movements == .rightAndLeft {
            if control == 1 {
                self.moveLeft()
            } else {
                self.moveRight()
            }
        } else {
            if control == 1 {
                self.moveDown()
            } else {
                self.moveUp()
            }
        }
    }
    
//    private func setUpTapGestureRecognizer() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
//        
//        self.view?.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        if sender.state == .recognized {
//            guard let index = localPlayerIndex else {
//                print("found index nil")
//                return
//            }
//            
//            self.gameModel.players[index].didJump = true
//            self.sendData {
//                print("data sent")
//                self.moveUp()
//            }
//        }
//    }
    
    private func savePlayers() {
        guard let remotePlayerName = match?.players.first?.displayName else { return }
        
        let localPlayer = Player(displayName: GKLocalPlayer.local.displayName, movements: .upAndDown)
        let remotePlayer = Player(displayName: remotePlayerName, movements: .rightAndLeft)
        
        var players = [localPlayer, remotePlayer]
        players.sort { (localPlayer, remotePlayer) -> Bool in
            localPlayer.displayName < remotePlayer.displayName
        }
        
        self.localPlayerIndex = players.firstIndex { $0.displayName == localPlayer.displayName }
        self.remotePlayerIndex = players.firstIndex { $0.displayName == remotePlayer.displayName }
        
        self.gameModel.players = players
        
        if let index = localPlayerIndex {
            if index == 0 {
                let movements = setMovementsForPlayer()
                gameModel.players[0].movements = movements[0]
                gameModel.players[1].movements = movements[1]
                
                sendData {
                    self.saveControls()
                }
            }
        }
    }
    
    private func setMovementsForPlayer() -> [Movements] {
        var allMovements: [Movements] = Movements.allCases
        var localPlayerMovements: Movements = .upAndDown
        var remotePlayerMovements: Movements = .upAndDown
        
        guard let movements = allMovements.randomElement() else { return [] }
        localPlayerMovements = movements
        
        guard let index = (allMovements.firstIndex { $0 == localPlayerMovements }) else { return [] }
        allMovements.remove(at: index)
        
        remotePlayerMovements = allMovements[0]
        
        return [localPlayerMovements, remotePlayerMovements]
    }
    
    private func setControlNodes() {
        guard let view = self.view else { return }
        
        control1 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: controls[0])!), size: CGSize(width: 50, height: 50))
        control1.anchorPoint = CGPoint(x: 0.5, y: 0)
        control1.position = CGPoint(x: 100, y: 100)
        
        control2 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: controls[1])!), size: CGSize(width: 50, height: 50))
        control2.anchorPoint = CGPoint(x: 0.5, y: 0)
        control2.position = CGPoint(x: view.frame.maxX - 100, y: 100)
        
        addChild(control1)
        addChild(control2)
    }
    
    private func saveControls() {
        guard let index = localPlayerIndex else { return }
        
        if gameModel.players[index].movements == .rightAndLeft {
            self.controls = ["arrow.left", "arrow.right"]
            sendControlsData(["arrow.down", "arrow.up"])
        } else {
            self.controls = ["arrow.down", "arrow.up"]
            sendControlsData(["arrow.left", "arrow.right"])
        }
    }
    
    private func sendControlsData(_ strings: [String]) {
        do {
            guard let data = try? JSONEncoder().encode(strings) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    private func updateUI() {
        guard self.gameModel.players.count >= 2 else { return }
        
        if let controls = self.controls, controls.count >= 2 {
            if !areControlNodesSet {
                setControlNodes()
                areControlNodesSet = false
            }
        }
        
        guard let remoteIndex = remotePlayerIndex else { return }
        
        if gameModel.players[remoteIndex].didMoveControl1 {
            gameModel.players[remoteIndex].didMoveControl1 = false
            
            sendData {
                self.checkMovement(for: 1, with: remoteIndex)
            }
        } else if gameModel.players[remoteIndex].didMoveControl2 {
            gameModel.players[remoteIndex].didMoveControl2 = false
            
            sendData {
                self.checkMovement(for: 2, with: remoteIndex)
            }
        }
    }
    
    private func sendData(completion: @escaping (() -> Void)) {
        guard let match = match else { return }
        
        do {
            guard let data = self.gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("Send data failed")
        }
    }
}

extension GameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // First guard let checks if data received is the controls or the gameModel
        guard let controls = try? JSONDecoder().decode([String].self, from: data) else {
            // If data is not the controls, then try decoding a gameModel
            guard let model = GameModel.decode(data: data) else { return }
            gameModel = model
            return
        }

        // If data is the controls, then update player's controls
        self.controls = controls
    }
}
