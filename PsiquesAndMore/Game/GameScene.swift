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
    private var rectangle = SKSpriteNode()
    
    // Don't forget to cancel this afterwards
    private var cancellables = Set<AnyCancellable>()
    
    var verticalThresholdPoint: CGFloat = 0
    var rectangleWidth: CGFloat = 0
    var rectangleHeigth: CGFloat = 0
    var rotationAngle: CGFloat = 0
    
    var squareYPosition: CGFloat = 0
    
    var backgroundSpeed: CGFloat! {
        didSet {
            rectangle.removeAllActions()
            moveBackground()
        }
    }
    
    var gameDuration: Int = 60
    
    var virtualController: GCVirtualController?
    
    // chao
//    var floor = SKSpriteNode(imageNamed: "floor")
    
    // fundo
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // pause button
    var pauseButton: SKSpriteNode?
    
    var isGamePaused: Bool = false
    
    var isGoToMenuOrderGiven: Bool = false
    
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
        
        verticalThresholdPoint = view.frame.height * 0.58
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) + (view.frame.width * view.frame.width))
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        rectangleHeigth = sin(rotationAngle) * view.frame.width

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!), size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1)
        rectangle.position = CGPoint(x: view.frame.width, y: 0)
        rectangle.zRotation = -(rotationAngle)
        
        addChild(rectangle)
        
        backgroundSpeed = 0
        
        createSubscriptions()
        
        savePlayers()
        
        triggerCharacter()
//        triggerfloor()
        setupPauseButton()
    }
    
    private func moveBackground() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
    
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        rectangle.run(SKAction.repeatForever(moveAction))
    }
    
    // MARK: - Combine functions
    private func createSubscriptions() {
        backgroundPositionUpdater()
        velocityUpdater()
        timerTracker()
    }
    
    private func backgroundPositionUpdater() {
        guard let view = self.view else { return }
        
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= 0 {
                    self.rectangle.position = CGPoint(x: view.frame.width, y: 0)
                }
            }.store(in: &cancellables)
    }
    
    private func velocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
    
    private func timerTracker() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                return count + 1
            }
            .sink { count in
                if count >= self.gameDuration {
                    print("time's up")
                    // perform game over
                }
            }.store(in: &cancellables)
    }
    
    func notifyPausedState(for order: OrderGiven, _ completion: @escaping (() -> Void)) {
        if order == .pauseGame {
            self.isGamePaused = true
            
            NotificationCenter.default.post(name: .pauseGameNotificationName, object: nil)
            print("DEBUG: pause game")
            completion()
        } else {
            self.isGamePaused = false
            
            NotificationCenter.default.post(name: .continueGameNotificationName, object: nil)
            print("DEBUG: continue game")
            completion()
        }
    }
    
    func sendPausedStateData() {
        do {
            guard let data = try? JSONEncoder().encode(self.isGamePaused) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send paused state data failed")
        }
    }
    
    private func notifyGoToMenu() {
        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
        print("DEBUG: go to menu")
    }
    
    func sendGoToMenuData() {
        do {
            guard let data = try? JSONEncoder().encode(OrderGiven.goToMenu) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send back to menu data failed")
        }
    }
    
    // comecando o chao
//    private func triggerfloor(){
//        let pb = SKPhysicsBody(texture: floor.texture!,
//                               size: floor.texture!.size())
//        
//        pb.isDynamic = false
//        pb.categoryBitMask
//        pb.contactTestBitMask
//        pb.collisionBitMask
//        
//        floor.physicsBody = pb
//        floor.name = "floor"
//        
//        floor.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
//        self.addChild(floor)
//        
//    }
    
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
    func triggerCommands() {
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputCommand()
    }
    
    // pegando os valores dos comandos
    func getInputCommand() {
           let left = createHeartBezierPath1()
           let right = createHeartBezierPath2()
           
           print("inside get input command function")
           
           guard let index = localPlayerIndex else { return }
           
           var leftButton: GCControllerButtonInput?
           var rightButton: GCControllerButtonInput?
           var stickXAxis: GCControllerAxisInput?
           
           func createHeartBezierPath1() -> UIBezierPath {
               let heartPath = UIBezierPath()
               
               // Define the main heart shape
               heartPath.move(to: CGPoint(x: -10, y: -20))
               heartPath.addCurve(to: CGPoint(x: -75, y: -75),
                                  controlPoint1: CGPoint(x: 150, y: 110),
                                  controlPoint2: CGPoint(x: 125, y: 75))
               heartPath.addCurve(to: CGPoint(x: 0, y: 140),
                                  controlPoint1: CGPoint(x: 25, y: 75),
                                  controlPoint2: CGPoint(x: 0, y: 110))
               heartPath.addLine(to: CGPoint(x: 150, y: 260))
               heartPath.addLine(to: CGPoint(x: 300, y: 140))
               heartPath.addLine(to: CGPoint(x: 150, y: 20))
               heartPath.close()
               
               return heartPath
           }
           
           func createHeartBezierPath2() -> UIBezierPath {
               let heartPath = UIBezierPath()
               
               // Define the main heart shape
               heartPath.move(to: CGPoint(x: 100, y: 40))
               heartPath.addCurve(to: CGPoint(x: 75, y: 75),
                                  controlPoint1: CGPoint(x: 150, y: 110),
                                  controlPoint2: CGPoint(x: 125, y: 75))
               heartPath.addCurve(to: CGPoint(x: 0, y: 140),
                                  controlPoint1: CGPoint(x: 25, y: 75),
                                  controlPoint2: CGPoint(x: 0, y: 110))
               heartPath.addLine(to: CGPoint(x: 150, y: 260))
               heartPath.addLine(to: CGPoint(x: 300, y: 140))
               heartPath.addLine(to: CGPoint(x: 150, y: 20))
               heartPath.close()
               
               return heartPath
               
           }

           // Usage
           
           
           if let virtualController, let controller = virtualController.controller, let extendedGamepad = controller.extendedGamepad {
               let element = GCInputButtonX
               
               virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                   currentConfiguration.path = right
                   return currentConfiguration
               }
           }
           
           if let virtualController, let controller = virtualController.controller, let extendedGamepad = controller.extendedGamepad {
               let element = GCInputLeftTrigger
               
               virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                   currentConfiguration.path = left
                   return currentConfiguration
               }
           }
           
          
           
           if let buttons = virtualController!.controller?.extendedGamepad {
               leftButton = buttons.leftTrigger
               leftButton?.sfSymbolsName = "arrow.up.and.down.and.sparkles"
   
   
               rightButton = buttons.buttonX
               rightButton!.sfSymbolsName = "square.and.arrow.up"
               rightButton!.unmappedSfSymbolsName = "square.and.arrow.up"
   
               virtualController!.updateConfiguration(forElement: GCInputButtonX) { configuration in
                   return configuration
               }
   
               stickXAxis = buttons.leftThumbstick.xAxis
           }
           
            //nao usando ainda
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
                       print("Clicked left")
                       leftButton?.sfSymbolsName = "arrowshape.left"
   
                       self.moveSpriteLeft()
                       self.gameModel.players[index].didMoveControl1 = true
   
                       self.sendData {
                           print("sending movement data")
                       }
                   } else {
                       print("Clicked right")
                       leftButton?.sfSymbolsName = "arrowshape.right"
                       self.moveSpriteRight()
                       self.gameModel.players[index].didMoveControl1 = true
   
                       self.sendData {
                           print("sending movement data")
                       }
                   }
               }
           }
           
           rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
               if pressed {
                   if self.gameModel.players[index].movements == .upAndLeft {
                       print("Clicked up") //arrow.up
                       rightButton?.sfSymbolsName = "arrow.up"
                       self.moveSpriteUP()
                       self.gameModel.players[index].didMoveControl2 = true
   
                       self.sendData {
                           print("sending movement data")
                       }
                   } else {
                       print("Clicked down")
                       rightButton?.sfSymbolsName = "arrow.down"
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
    func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        rectangle.removeFromParent()
        backgroundImage.removeFromParent()
        removeComands()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
    }
    
    // moveu para cima
    private func moveSpriteUP() {
        print("moving up")
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
    }
    
    // moveu para baixo
    private func moveSpriteDown() {
        print("moving down")
        square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
    }
    
    // moveu para a esquerda
    private func moveSpriteLeft() {
        print("moving left")
        square.run(.move(to: CGPoint(x: square.position.x - 10, y: square.position.y), duration: 0.2))
        
    }
    
    private func moveSpriteRight() {
        print("moving right")
        square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
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
    
    private func saveControls() {
        print("saving controls")
        guard let index = localPlayerIndex else { return }
        
        if gameModel.players[index].movements == .downAndRight {
            sendControlsData(.upAndLeft)
        } else {
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
        // Check if it's the game model data
        if let model = GameModel.decode(data: data) {
            gameModel = model
        }
        
        // Check if it's the controls data
        if let controls = try? JSONDecoder().decode(Movements.self, from: data) {
            guard let localIndex = localPlayerIndex else { return }
            gameModel.players[localIndex].movements = controls
            self.triggerCommands()
        }
        
        // Check if it's the paused state data
        if let pausedState = try? JSONDecoder().decode(Bool.self, from: data) {
            print("paused state data received")
            if pausedState {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .pauseGame) {
                    print("Notifying...")
                }
            } else {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .continueGame) {
                    print("Notifying...")
                }
            }
        }
        
        // Check if it's the go to menu data
        if let goToMenu = try? JSONDecoder().decode(OrderGiven.self, from: data) {
            print("back to menu data received")
            if goToMenu == .goToMenu {
                self.isGoToMenuOrderGiven = true
                self.notifyGoToMenu()
            }
        }
    }
}
