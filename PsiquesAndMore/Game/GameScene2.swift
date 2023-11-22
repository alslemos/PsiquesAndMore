import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene2: SKScene {
    // tempo
    
    var virtualController: GCVirtualController?
    //var square = SKSpriteNode()
    private var CharacterVelocity: Int = 0
    
    private var square = SKSpriteNode(imageNamed: "Vector-0")
    var entidadeFrames = [SKTexture]()
    var textureAtlass = SKTextureAtlas(named: "entidadeAnimada")
    
    
    var entidadeFramesAbaixando = [SKTexture]()
    var textureAtlassAbaixando = SKTextureAtlas(named: "entidadeAbaixando")
    
    
    
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    // chao
    private let floor = SKSpriteNode(imageNamed: "floor")
    
    private var timerLabel = SKLabelNode()
    
    var pauseButton: SKSpriteNode?
    var heartArray: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        triggerCommands()
        triggerFloor()
        triggerBackground()
        setupPauseButton()
        triggerTimer()
        triggerLives()
//        updateAsset()
        updateAssetSeAbaixando()
        
//        for node in self.children {
//            if node.name == "square" {
//                if let someTileMap: SKTileMapNode = node as? SKTileMapNode {
//                    ti
//
//                }
//            }
//        }
        
        
        func updateAsset(){
            
            var auxiliar: Int = 0
            
            for i in 0..<textureAtlass.textureNames.count {
                let textureNames = "Vector" + "-" + String(i)
                entidadeFrames.append(textureAtlass.textureNamed(textureNames))
            }
            print(entidadeFrames.count)
            
            square.run(SKAction.repeatForever(SKAction.animate(with: entidadeFrames, timePerFrame: 0.5)))
            
        }
        
       
        func updateAssetSeAbaixando(){
            
            var auxiliar: Int = 0
            
            for i in 0..<textureAtlassAbaixando.textureNames.count {
                let textureNames = "Vector" + "-" + String(i)
                entidadeFramesAbaixando.append(textureAtlassAbaixando.textureNamed(textureNames))
            }
            print(entidadeFramesAbaixando.count)
            
            square.run(SKAction.repeatForever(SKAction.animate(with: entidadeFramesAbaixando, timePerFrame: 0.5)))
            
        }
        
        
        triggerCharacter()
        
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        square.physicsBody?.applyForce(CGVector(dx: CharacterVelocity, dy: 0))
        
        if Int.random(in: 0...20) > 19 {
            CharacterVelocity += 1
            print(CharacterVelocity)
        }
        
       
        
        
        // vai aumentar
    }
    /// criando elementos visuais
    ///
    ///
    
    func triggerTimer(){
        //        timerLabel.position = CGPoint(x: label.position.x, y: label.position.y - 50)
        
        
        
        timerLabel.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.maxY - 64)
        
        timerLabel.fontColor = .white
        timerLabel.numberOfLines = 1
        timerLabel.fontSize = 20
        timerLabel.zPosition = 1
        addChild(timerLabel)
        
        startTimer()
    }
    
    
    func startTimer(){
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            subscription.cancel()
        }
    }
    
    // personagem
    func triggerBackground(){
        backgroundImage.zPosition = 0
        backgroundImage.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        addChild(backgroundImage)
    }
    
    func triggerCharacter(){
        print("Disparou personagem")
        
        let pb = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))// SKPhysicsBody(texture: square.texture!, size: square.texture!.size())
        
        //        square.anchorPoint = CGPoint(x: 0.0, y: 0)
        
        
        pb.contactTestBitMask = 0x00000001
        pb.allowsRotation = false
        pb.isDynamic = true
        //        pb.node?.physicsBody?.mass = 16.0
        pb.node?.physicsBody?.friction = 0.0
        pb.node?.physicsBody?.affectedByGravity = true
        
        square.zPosition = 1
        square.physicsBody = pb
        square.name = "square"
        square.position = CGPoint(x: (self.view?.frame.minX)! + 50, y: (self.view?.frame.midY)! + 100)
        
        self.addChild(square)
    }
    
    
    // comecando os comandos
    func triggerCommands(){
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputCommand()
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
        pauseButton.zPosition = 1
        
        addChild(pauseButton)
    }
    
    func triggerLives() {
        //heartArray
        print("Nas vidas manorlo")
        
        let heartButton = SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "heart.fill") ?? UIImage()))
        heartButton.size = CGSize(
            width: 32,
            height: 32)
        
        
        heartButton.position = CGPoint(
            x: self.frame.minX + 30,
            y: self.frame.maxY - 64)
        heartButton.zPosition = 50
        heartButton.name = "pauseButton"
        heartButton.zPosition = 1
        
        addChild(heartButton)
    }
    
    
    private func triggerFloor(){
        let pb = SKPhysicsBody(texture: floor.texture!,
                               size: floor.texture!.size())
        
        pb.isDynamic = false
        pb.node?.physicsBody?.friction = 0.0
        floor.zPosition = 1
        floor.physicsBody = pb
        floor.name = "floor"
        
        floor.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.minY)! + 100 )
        self.addChild(floor)
    }
        
    ///
    // pegando os valores dos comandos
    func getInputCommand() {
        let left = createHeartBezierPath1()
       
       
        let right = createHeartBezierPath2()
        
      
        var leftButton: GCControllerButtonInput?
        var rightButton: GCControllerButtonInput?
        var stickXAxis: GCControllerAxisInput?
        
        func createHeartBezierPath1() -> UIBezierPath {
            let path = UIBezierPath()

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -0.7, y:0))
            path.addLine(to: CGPoint(x: -0.3, y:0.09))
            path.addLine(to: CGPoint(x: -0.3, y:0.02))
            // meio
            path.addLine(to: CGPoint(x: 0.3, y:0.02))
            path.addLine(to: CGPoint(x: 0.3, y:0.09))
            path.addLine(to: CGPoint(x: 0.7, y:0))
            // agora voltando
            path.addLine(to: CGPoint(x: 0.3, y: -0.09))
            path.addLine(to: CGPoint(x: 0.3, y: -0.02))
            
            path.addLine(to: CGPoint(x: -0.3, y: -0.02))
            path.addLine(to: CGPoint(x: -0.3, y: -0.09))
            
            path.addLine(to: CGPoint(x: -0.7, y: 0))
 
            
            path.close()
            
            return path
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
        
        
        
        
        leftButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            
            
            if pressed {
                
                print("pressionou, pulou ")
                self.square.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
                
            }
        }
        
        
    }
    
    // removendo os comandos da tela
    private func removeComands(){
        virtualController?.disconnect()
    }
    
  
    
    
    
}
