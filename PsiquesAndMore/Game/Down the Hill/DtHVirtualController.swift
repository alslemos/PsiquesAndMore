import Foundation
import GameController
import SpriteKit

extension GameScene {
    // MARK: - Down the Hill Game
    func setupVirtualController() {
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController?.connect()
        getInputCommand()
    }
    
    func getInputCommand() {
        var leftButton: GCControllerButtonInput?
        var rightButton: GCControllerButtonInput?
        var stickXAxis: GCControllerAxisInput?
        
        guard let index = localPlayerIndex else { return }
        
        print("inside get input command function")
        
        let left = createHeartBezierPath1()
        let right = createHeartBezierPath2()
        
        // personaliza o botao da diretaa
        if let virtualController, let controller = virtualController.controller, let _ = controller.extendedGamepad {
            let element = GCInputButtonX
            
            virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                currentConfiguration.path = right
                return currentConfiguration
            }
        }
        
        // personaliza o botao da esquerda
        if let virtualController, let controller = virtualController.controller, let _ = controller.extendedGamepad {
            let element = GCInputLeftTrigger
            
            virtualController.updateConfiguration(forElement: element) { currentConfiguration in
                currentConfiguration.path = left
                return currentConfiguration
            }
        }
        
        // definicao dos botoes
        if let buttons = virtualController?.controller?.extendedGamepad {
            leftButton = buttons.leftTrigger
            rightButton = buttons.buttonX
            
            virtualController?.updateConfiguration(forElement: GCInputButtonX) { configuration in
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
                if self.players[index].controls == .upAndLeft {
                    print("Clicked left")
                    leftButton?.sfSymbolsName = "arrowshape.left"
                    
                    if !self.isPlayerMoving {
                        self.sendMovementData(.left) {
                            self.moveSprite(.left)
                        }
                    } else {
                        print("cannot move")
                    }
                } else {
                    print("Clicked right")
                    leftButton?.sfSymbolsName = "arrowshape.right"
                    
                    if !self.isPlayerMoving {
                        self.sendMovementData(.right) {
                            self.moveSprite(.right)
                        }
                    } else {
                        print("cannot move")
                    }
                }
            }
        }
        
        rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            if pressed {
                if self.players[index].controls == .upAndLeft {
                    print("Clicked up") //arrow.up
                    rightButton?.sfSymbolsName = "arrow.up"
                    
                    if !self.isPlayerMoving && self.isPlayerTouchingFloor {
                        self.sendMovementData(.up) {
                            print("moving up")
                            self.moveSprite(.up)
                        }
                    } else {
                        print("cannot move")
                    }
                } else {
                    print("Clicked down")
                    rightButton?.sfSymbolsName = "arrow.down"
                    
                    if !self.isPlayerMoving {
                        self.sendMovementData(.down) {
                            print("moving down")
                            self.moveSprite(.down)
                        }
                    } else {
                        print("cannot move")
                    }
                }
            }
        }
    }
    
    func removeCommands() {
        virtualController?.disconnect()
    }
}
