import SwiftUI
import GameController
import GameKit
import SpriteKit
import Combine



class GameViewController: UIViewController {
    // Virtual Onscreen Controller
    private var _virtualController: Any?
    @available(iOS 15.0, *)
    public var virtualController: GCVirtualController? {
        get { return self._virtualController as? GCVirtualController }
        set { self._virtualController = newValue }
    }
}



class GameScene: SKScene {
        
    // tempo
    private var label = SKLabelNode()
    private var timerLabel = SKLabelNode()
    
    var virtualController: GCVirtualController?
    
    
    // fundo
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // chao
    private var floor = SKSpriteNode(imageNamed: "floor")
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    private var square = SKSpriteNode()
    
    // logica do jogo
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    var gameModel: GameModel! {
        didSet {
            updateUI()
        }
    }
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        match?.delegate = self
        
        savePlayers()
        
        triggerfloor()
        triggerComands()
        
        square = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
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
    
    private func triggerfloor(){
        // floor
        let physicsBodyFloor = SKPhysicsBody(rectangleOf: CGSize(width: 220, height: 844))
        physicsBodyFloor.contactTestBitMask = 0x00000001
        physicsBodyFloor.affectedByGravity = false
        physicsBodyFloor.allowsRotation = false
        physicsBodyFloor.isDynamic = false;
        
        floor.physicsBody = physicsBodyFloor
        floor.name = "floor"
        
        self.floor.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        self.addChild(floor)
        
    }
    
    func triggerComands(){
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputComand()
    }
    
    func getInputComand() {
        var jumpButton: GCControllerButtonInput?
        var actionButton: GCControllerButtonInput?
        var stickXAxis: GCControllerAxisInput?
        
        if let buttons = virtualController!.controller?.extendedGamepad {
            jumpButton = buttons.buttonA
            actionButton = buttons.buttonB
            stickXAxis = buttons.leftThumbstick.xAxis
        }
        stickXAxis?.valueChangedHandler = {
            ( _ button: GCControllerAxisInput, _ value: Float) -> Void in
            print(value)
            
            // faz algo com essa info
            
            if value == 0.0 {
                // faz algo
            }
        }
        jumpButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            
            if pressed {
                // faz algo
                print("Botao a pressionado")
            }
        }
        
        actionButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            
            if pressed {
                // faz algo
                print("Botao B pressionado")
            }
        }
        
        
    }
    
    
    func removeComands(){
        virtualController?.disconnect()
    }
    
    
    private func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        label.removeFromParent()
        timerLabel.removeFromParent()
        removeComands()
        
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
