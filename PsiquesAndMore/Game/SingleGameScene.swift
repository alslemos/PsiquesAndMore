import SwiftUI
import GameController
import GameKit
import SpriteKit
import Combine


class SingleGameScene: SKScene {
    var rectangle = SKSpriteNode()
    
    // Don't forget to cancel this afterwards
    private var cancellables = Set<AnyCancellable>()
    
    // unica propriedade que n dá mt para tirar
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
    
    // fundo
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // pause button
    var pauseButton: SKSpriteNode?
    
    var isGamePaused: Bool = false
    
    var isGoToMenuOrderGiven: Bool = false
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    var square = SKSpriteNode()
    
    // obstacle
    
    var obstacle = SKSpriteNode()
    
    var isControlSet: Bool = false
    
    var controls: Movements? = nil
    
    var areControlNodesSet: Bool = false
    
    var startDate: Date? = nil
    
    override func didMove(to view: SKView) {
        setupPauseButton()
        setupCharacter()
        setupFloor()
        
        setStartDate()
        
        backgroundSpeed = 0
        createSubscriptions()
        savePlayer()
    }
    
    func setStartDate() {
        startDate = Date.now
        print("date: \(startDate)")
        
        guard let date = startDate else { return }
        
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        print("minutes: \(minutes)")
        print("seconds: \(seconds)")
    }
    
    func savePlayer() {
        var allMovements: [Movements] = Movements.allCases
        
        guard let movements = allMovements.randomElement() else { return }
        controls = movements
        
        setupCommands()
    }
    
    func setupCommands(){
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputCommand()
    }
    
    func getInputCommand(){
        
        var leftButton: GCControllerButtonInput?
        var rightButton: GCControllerButtonInput?
        var stickXAxis: GCControllerAxisInput?
        
        print("inside get input command function")
        
        let left = createHeartBezierPath1()
        let right = createHeartBezierPath2()
        
        // personaliza o botao da diretaa
        if let virtualController, let controller = virtualController.controller, let extendedGamepad = controller.extendedGamepad {
            let element = GCInputButtonX
            
            virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                currentConfiguration.path = right
                return currentConfiguration
            }
        }
        
        // personaliza o botao da esquerda
        if let virtualController, let controller = virtualController.controller, let extendedGamepad = controller.extendedGamepad {
            let element = GCInputLeftTrigger
            
            virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                currentConfiguration.path = left
                return currentConfiguration
            }
        }
        
        // definicao dos botoes
        if let buttons = virtualController!.controller?.extendedGamepad {
            leftButton = buttons.leftTrigger
            rightButton = buttons.buttonX
            
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
                if self.controls == .upAndLeft {
                    print("Clicked left")
                    leftButton?.sfSymbolsName = "arrowshape.left"
                    
                    self.moveSpriteLeft()
                } else {
                    print("Clicked right")
                    leftButton?.sfSymbolsName = "arrowshape.right"
                    self.moveSpriteRight()
                }
            }
        }
        
        rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            if pressed {
                if self.controls == .upAndLeft {
                    print("Clicked up") //arrow.up
                    rightButton?.sfSymbolsName = "arrow.up"
                    self.moveSpriteUP()
                } else {
                    print("Clicked down")
                    rightButton?.sfSymbolsName = "arrow.down"
                    self.moveSpriteDown()
                }
            }
        }
    }
    
    func removeComands(){
        virtualController?.disconnect()
    }
    
    func setupFloor(){
        var verticalThresholdPoint: CGFloat = 0
        var rectangleWidth: CGFloat = 0
        var rectangleHeigth: CGFloat = 0
        
        verticalThresholdPoint = (self.view?.frame.height)! * 0.58
        
        rectangleWidth = sqrt((verticalThresholdPoint * verticalThresholdPoint) +
                              ((self.view?.frame.width)! * (self.view?.frame.width)!))
        
        rotationAngle = asin(verticalThresholdPoint / rectangleWidth)
        
        rectangleHeigth = sin(rotationAngle) * (self.view?.frame.width)!

        rectangle = SKSpriteNode(texture: SKTexture(image: UIImage(named: "agoraVai")!),
                                 size: CGSize(width: rectangleWidth * 2, height: rectangleHeigth))
      
        rectangle.name = "floor"
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1)
        rectangle.position = CGPoint(x: (self.view?.frame.width)!, y: 0)
        rectangle.zRotation = -(rotationAngle)
        
        addChild(rectangle)
    }
    
     func moveBackground() {
        let deltaX = 30.0
        let deltaY = deltaX * Double(tan(.pi - rotationAngle))
    
        let moveAction = SKAction.move(by: CGVector(dx: -(deltaX * backgroundSpeed), dy: -(deltaY * backgroundSpeed)), duration: 1)
        
        rectangle.run(SKAction.repeatForever(moveAction))
    }
    
    func setupCharacter(){
        square = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        square.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let physicsBodyCharacter = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
        physicsBodyCharacter.contactTestBitMask = 0x00000001
        physicsBodyCharacter.affectedByGravity = false
        physicsBodyCharacter.allowsRotation = false
        physicsBodyCharacter.isDynamic = true
        physicsBodyCharacter.affectedByGravity = false // Jesus
        
        square.physicsBody = physicsBodyCharacter
        square.name = "character"
        square.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        
        self.addChild(square)
    }
    
    func moveSpriteUP() {
       print("moving up")
       square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y + 50), duration: 0.2))
   }
   
   // moveu para baixo
    func moveSpriteDown() {
       print("moving down")
       square.run(.move(to: CGPoint(x: square.position.x, y: square.position.y - 50), duration: 0.2))
   }
   
   // moveu para a esquerda
    func moveSpriteLeft() {
       print("moving left")
       square.run(.move(to: CGPoint(x: square.position.x - 10, y: square.position.y), duration: 0.2))
       
   }
   
    func moveSpriteRight() {
       print("moving right")
       square.run(.move(to: CGPoint(x: square.position.x + 50, y: square.position.y), duration: 0.2))
   }
    
   
    
    // MARK: - Combine functions
    private func createSubscriptions() {
        backgroundPositionUpdater()
        velocityUpdater()
        timerTracker()
        obstacleSpawner()
    }
    
    private func obstacleSpawner() {
        print("DEBUG: inside obstacleSpawner")
        let publisher = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        
        
        subscription
            .map { _ in
                self.setupObstacle()
                return self.obstacle
            }
            .sink { obstacle in
                self.moveObstacle(time: Double.random(in: 0.5...2.0), positionOffsetX: 0.0, positionOffsetY: Double.random(in: 0.0...400.0), completion: {
                    print("DEBUG: inside closure")
                    print("\(self.view?.frame.maxX ?? 0)")
                    print("\(self.view?.frame.maxY ?? 0)")
                    if let child = self.childNode(withName: "obstacle") as? SKSpriteNode {
                        print("DEBUG: child node exists")
                        child.removeFromParent()
                    }
                })
            }.store(in: &cancellables)
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
    
    func setupPauseButton() {
        let pauseButton = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "pause.fill") ?? UIImage()))
        pauseButton.size = CGSize(
            width: 32,
            height: 32)
        pauseButton.position = CGPoint(
            x: self.frame.maxX - 64,
            y: self.frame.maxY - 64)
        pauseButton.zPosition = 50
        pauseButton.name = "pauseButton"
        self.pauseButton = pauseButton
        self.addChild(pauseButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let pauseButton = pauseButton {
                if pauseButton.contains(touch.location(in: self)) {
                    notifyPausedState(for: .pauseGame) {
                        print("notifying paused state")
                    }
                }
            }
        }
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
    
    func notifyGoToMenu() {
        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
        print("DEBUG: go to menu")
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
    
    private func updateUI() {
        
    }
}

//
extension SingleGameScene {
    
    func setupObstacle() {
        let obstacle = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let physicsBodyObstacle = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        physicsBodyObstacle.contactTestBitMask = 0x00000001
        physicsBodyObstacle.affectedByGravity = false
        physicsBodyObstacle.allowsRotation = false
        physicsBodyObstacle.isDynamic = true
        obstacle.physicsBody = physicsBodyObstacle
        obstacle.position = CGPoint(x: (self.view?.frame.maxX) ?? 0 + 100, y: (self.view?.frame.midY) ?? 0)
        obstacle.name = "obstacle"
        self.obstacle = obstacle
        self.addChild(obstacle)
    }
    
    func moveObstacle(time: Double, positionOffsetX: Double, positionOffsetY: Double, completion: @escaping () -> Void) {
        let moveAction = SKAction.move(to: CGPoint(
            x: (self.view?.frame.minX ?? 0) + positionOffsetX - 100,
            y: (self.view?.frame.midY ?? 0) + positionOffsetY + ((self.view?.frame.height ?? 0.0) * 0.50)),
            duration: time)
        obstacle.run(moveAction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time + 1.0) {
            completion()
        }

    }
    
}
//
