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
    private var timerLabel = SKLabelNode()
    
    var virtualController: GCVirtualController?
    
    // chao
    private let floor = SKSpriteNode(imageNamed: "floor")
    
    // fundo
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    private var square = SKSpriteNode()
    
    // logica do jogo
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
        
        triggerCharacter()
        triggerfloor()
        triggerCommands()
        
        timerLabel.position = CGPoint(x: view.frame.midX, y: view.frame.maxY - 150)
        timerLabel.fontColor = .white
        timerLabel.numberOfLines = 1
        timerLabel.fontSize = 20
        
        //        addChild(square)
        addChild(timerLabel)
        
        //        startTimer()
        //        setUpTapGestureRecognizer()
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            let location = touch.location(in: self)
    //            let nodesAtPoint = nodes(at: location)
    //
    //            for node in nodesAtPoint {
    //                if node == control1 {
    //                    guard let localIndex = localPlayerIndex else { return }
    //
    //                    self.gameModel.players[localIndex].didMoveControl1 = true
    //
    //                    self.sendData {
    //                        self.checkMovement(for: 1, with: localIndex)
    //                    }
    //                }
    //
    //                if node == control2 {
    //                    guard let localIndex = localPlayerIndex else { return }
    //
    //                    self.gameModel.players[localIndex].didMoveControl2 = true
    //
    //                    self.sendData {
    //                        self.checkMovement(for: 2, with: localIndex)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    // comecando o timer
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
    
    // comecando o chao
    private func triggerfloor(){
        // floor
        // var floor = SKSpriteNode(imageNamed: "floor")
        
        // floor.physicsBody = SKPhysicsBody(texture: floor.texture!,
        // size: floor.texture!.size())
        let pb = SKPhysicsBody(texture: floor.texture!,
                               size: floor.texture!.size())
        
        pb.isDynamic = false
        pb.categoryBitMask
        pb.contactTestBitMask
        pb.collisionBitMask
        
        floor.physicsBody = pb
        // let physicsBodyFloor = SKPhysicsBody(rectangleOf: CGSize(width: 220, height: 844))
        // physicsBodyFloor.contactTestBitMask = 0x00000001
        // physicsBodyFloor.affectedByGravity = false
        // physicsBodyFloor.allowsRotation = false
        // physicsBodyFloor.isDynamic = false;
        
        // floor.physicsBody = physicsBodyFloor
        floor.name = "floor"
        
        floor.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        self.addChild(floor)
        
    }
    
    // comecando o chao
    private func triggerCharacter(){
        square = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // floor
        let physicsBodyCharacter = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
        physicsBodyCharacter.contactTestBitMask = 0x00000001
        physicsBodyCharacter.affectedByGravity = false
        physicsBodyCharacter.allowsRotation = false
        physicsBodyCharacter.isDynamic = true
        
        square.physicsBody = physicsBodyCharacter
        square.name = "character"
        square.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        
        self.addChild(square)
    }
    
    
    
    // comecando os comandos
    func triggerCommands(){
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputComand()
    }
    
    // pegando os valores dos comandos
    func getInputComand() {
        guard let index = localPlayerIndex else { return }
        
        var leftButton: GCControllerButtonInput?
        var rightButton: GCControllerButtonInput?
        var stickXAxis: GCControllerAxisInput?
        
        if let buttons = virtualController!.controller?.extendedGamepad {
            leftButton = buttons.leftTrigger
            rightButton = buttons.buttonX
            stickXAxis = buttons.leftThumbstick.xAxis
        }
        
        // nao usando ainda
        stickXAxis?.valueChangedHandler = {
            ( _ button: GCControllerAxisInput, _ value: Float) -> Void in
            print(value)
            
            // faz algo com essa info
            
            if value == 0.0 {
                // faz algo
            }
        }
        
        leftButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            if pressed {
                if self.gameModel.players[index].movements == .upAndLeft {
                    print("Moved left")
                    
                    self.moveSpriteLeft()
                    self.gameModel.players[index].didMoveControl1 = true
                    
                    self.sendData {
                        print("sending movement data")
                    }
                } else {
                    print("Moved right")
                    
                    self.moveSpriteRight()
                    self.gameModel.players[index].didMoveControl2 = true
                    
                    self.sendData {
                        print("sending movement data")
                    }
                }
            }
        }
        
        rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            if pressed {
                if self.gameModel.players[index].movements == .upAndLeft {
                    print("Moved up")
                    
                    self.moveSpriteUP()
                    self.gameModel.players[index].didMoveControl1 = true
                    
                    self.sendData {
                        print("sending movement data")
                    }
                } else {
                    print("Moved down")
                    
                    self.moveSpriteDown()
                    self.gameModel.players[index].didMoveControl2 = true
                    
                    self.sendData {
                        print("sending movement data")
                    }
                }
            }
        }
    }
    
    // removendo os comandos da tela
    func removeComands(){
        virtualController?.disconnect()
    }
    
    // fim de jogo
    private func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        timerLabel.removeFromParent()
        floor.removeFromParent()
        backgroundImage.removeFromParent()
        
        //        control1.removeFromParent()
        //        control2.removeFromParent()
        removeComands()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
    }
    
    // moveu para cima
    private func moveSpriteUP() {
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            self.square.run(.move(to: CGPoint(x: self.square.position.x, y: self.square.position.y - 50), duration: 0.2))
        //        }
    }
    
    // moveu para baixo
    private func moveSpriteDown() {
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            self.square.run(.move(to: CGPoint(x: self.square.position.x, y: self.square.position.y + 50), duration: 0.2))
        //        }
    }
    
    // moveu para a esquerda
    private func moveSpriteLeft() {
        square.run(.move(to: CGPoint(x: square.position.x - 10, y: square.position.y), duration: 0.2))
        
    }
    
    private func moveSpriteRight() {
        square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            self.square.run(.move(to: CGPoint(x: self.square.position.x - 50, y: self.square.position.y), duration: 0.2))
        //        }
    }
    
    private func checkMovement(for control: Int, with playerIndex: Int) {
        if self.gameModel.players[playerIndex].movements == .downAndRight {
            if control == 1 {
                self.moveSpriteRight()
            } else {
                self.moveSpriteDown()
            }
        } else {
            if control == 1 {
                self.moveSpriteLeft()
            } else {
                self.moveSpriteUP()
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
        
        let localPlayer = Player(displayName: GKLocalPlayer.local.displayName, movements: .upAndLeft)
        let remotePlayer = Player(displayName: remotePlayerName, movements: .downAndRight)
        
        var players = [localPlayer, remotePlayer]
        players.sort { (localPlayer, remotePlayer) -> Bool in
            localPlayer.displayName < remotePlayer.displayName
        }
        
        self.localPlayerIndex = players.firstIndex { $0.displayName == localPlayer.displayName }
        self.remotePlayerIndex = players.firstIndex { $0.displayName == remotePlayer.displayName }
        
        self.gameModel.players = players
        
        if let index = localPlayerIndex {
            if index == 0 {
                print("sou o player principal")
                let movements = setMovementsForPlayer()
                gameModel.players[0].movements = movements[0]
                gameModel.players[1].movements = movements[1]
                
                sendData {
                    print("sending game model data")
                    self.saveControls()
                    print("triggering commands")
                    self.triggerCommands()
                }
            }
        }
    }
    
    private func setMovementsForPlayer() -> [Movements] {
        var allMovements: [Movements] = Movements.allCases
        var localPlayerMovements: Movements = .upAndLeft
        var remotePlayerMovements: Movements = .downAndRight
        
        guard let movements = allMovements.randomElement() else { return [] }
        localPlayerMovements = movements
        
        guard let index = (allMovements.firstIndex { $0 == localPlayerMovements }) else { return [] }
        allMovements.remove(at: index)
        
        remotePlayerMovements = allMovements[0]
        
        print("my movements: \(localPlayerMovements)")
        print("his movements: \(remotePlayerMovements)")

        
        return [localPlayerMovements, remotePlayerMovements]
    }
    
    // private func setControlNodes() {
    //     guard let view = self.view else { return }
    
    //     control1 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: controls[0])!), size: CGSize(width: 50, height: 50))
    //     control1.anchorPoint = CGPoint(x: 0.5, y: 0)
    //     control1.position = CGPoint(x: 100, y: 100)
    
    //     control2 = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: controls[1])!), size: CGSize(width: 50, height: 50))
    //     control2.anchorPoint = CGPoint(x: 0.5, y: 0)
    //     control2.position = CGPoint(x: view.frame.maxX - 100, y: 100)
    
    //     addChild(control1)
    //     addChild(control2)
    // }
    
    private func saveControls() {
        print("saving controls")
        guard let index = localPlayerIndex else { return }
        
        if gameModel.players[index].movements == .downAndRight {
            //            self.controls = ["arrow.left", "arrow.right"]
            sendControlsData(.upAndLeft)
        } else {
            //            self.controls = ["arrow.down", "arrow.up"]
            sendControlsData(.downAndRight)
        }
    }
    
    private func sendControlsData(_ movements: Movements) {
        print("sending controls data")
        do {
            guard let data = try? JSONEncoder().encode(movements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    private func updateUI() {
        guard self.gameModel.players.count >= 2 else { return }
        
        if let controls = self.controls, controls.count >= 2 {
            if !areControlNodesSet {
                //                setControlNodes()
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
        guard let controls = try? JSONDecoder().decode(Movements.self, from: data) else {
            // If data is not the controls, then try decoding a gameModel
            guard let model = GameModel.decode(data: data) else { return }
            gameModel = model
            return
        }
        
        // If data is the controls, then update player's controls
        guard let index = localPlayerIndex else { return }
        gameModel.players[index].movements = controls
        self.triggerCommands()
    }
}
