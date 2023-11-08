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
    
    private var square = SKSpriteNode(imageNamed: "personagem")
    
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    // chao
    private let floor = SKSpriteNode(imageNamed: "floor")
    
    
    override func didMove(to view: SKView) {
        triggerCommands()
        triggerFloor()
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
    
    // personagem
    
  
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
    
    
    private func triggerFloor(){
        // floor
        let pb = SKPhysicsBody(texture: floor.texture!,
                               size: floor.texture!.size())
        
        pb.isDynamic = false
        pb.node?.physicsBody?.friction = 0.0
        
        // pb.categoryBitMask
        // pb.contactTestBitMask
        // pb.collisionBitMask
        
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
        
        print("inside get input command function")
        
    //    guard let index = localPlayerIndex else { return }
        
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
