import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene2: SKScene {
    // tempo
    
    var virtualController: GCVirtualController?
    
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMove(to view: SKView) {
        triggerCommands()
    }
    
    /// criando elementos visuais
    ///
    ///
    
    // comecando os comandos
    func triggerCommands(){
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController!.connect()
        getInputCommand()
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
        
       
        
//        if let buttons = virtualController!.controller?.extendedGamepad {
//            leftButton = buttons.leftTrigger
//            leftButton?.sfSymbolsName = "arrow.up.and.down.and.sparkles"
//            
//            
//            rightButton = buttons.buttonX
//            rightButton!.sfSymbolsName = "square.and.arrow.up"
//            rightButton!.unmappedSfSymbolsName = "square.and.arrow.up"
//            
//            virtualController!.updateConfiguration(forElement: GCInputButtonX) { configuration in
//                return configuration
//            }
//            
//            stickXAxis = buttons.leftThumbstick.xAxis
//        }
        
        // nao usando ainda
//        stickXAxis?.valueChangedHandler = {
//            ( _ button: GCControllerAxisInput, _ value: Float) -> Void in
//            print(value)
//            
//            // faz algo com essa info
//            
//            if value == 0.0 {
//                // faz algo
//            }
//        }
        
//        leftButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
//            if pressed {
//                if self.gameModel.players[index].movements == .upAndLeft {
//                    print("Clicked left")
//                    leftButton?.sfSymbolsName = "arrowshape.left"
//                    
//                    self.moveSpriteLeft()
//                    self.gameModel.players[index].didMoveControl1 = true
//                    
//                    self.sendData {
//                        print("sending movement data")
//                    }
//                } else {
//                    print("Clicked right")
//                    leftButton?.sfSymbolsName = "arrowshape.right"
//                    self.moveSpriteRight()
//                    self.gameModel.players[index].didMoveControl1 = true
//                    
//                    self.sendData {
//                        print("sending movement data")
//                    }
//                }
//            }
//        }
        
//        rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
//            if pressed {
//                if self.gameModel.players[index].movements == .upAndLeft {
//                    print("Clicked up") //arrow.up
//                    rightButton?.sfSymbolsName = "arrow.up"
//                    self.moveSpriteUP()
//                    self.gameModel.players[index].didMoveControl2 = true
//                    
//                    self.sendData {
//                        print("sending movement data")
//                    }
//                } else {
//                    print("Clicked down")
//                    rightButton?.sfSymbolsName = "arrow.down"
//                    self.moveSpriteDown()
//                    self.gameModel.players[index].didMoveControl2 = true
//                    
//                    self.sendData {
//                        print("sending movement data")
//                    }
//                }
//            }
//        }
    }
    
    
    
    // removendo os comandos da tela
    private func removeComands(){
        virtualController?.disconnect()
    }
    
    
    
}
