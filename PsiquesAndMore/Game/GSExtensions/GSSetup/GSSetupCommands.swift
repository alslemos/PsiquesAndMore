//
//  GSSetupCommands.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 06/11/23.
//

import Foundation
import GameController



class GameViewController: UIViewController {
    // Virtual Onscreen Controller
    private var _virtualController: Any?
    @available(iOS 15.0, *)
    public var virtualController: GCVirtualController? {
        get { return self._virtualController as? GCVirtualController }
        set { self._virtualController = newValue }
    }
}

extension GameScene {
    func setupCommands(){
        print("inside trigger comands function")
        let virtualControllerConfig = GCVirtualController.Configuration()
        virtualControllerConfig.elements = [GCInputLeftTrigger, GCInputButtonX]
        
        virtualController = GCVirtualController(configuration: virtualControllerConfig)
        virtualController?.connect()
        getInputCommand()
        
    }
    
    func getInputCommand(){
        
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
                    
                    self.sendMovementData(.left) {
                        self.moveSprite(.left)
                    }
                } else {
                    print("Clicked right")
                    leftButton?.sfSymbolsName = "arrowshape.right"
                    
                    self.sendMovementData(.right) {
                        self.moveSprite(.right)
                    }
                }
            }
        }
        
        rightButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            if pressed {
                if self.players[index].controls == .upAndLeft {
                    print("Clicked up") //arrow.up
                    rightButton?.sfSymbolsName = "arrow.up"
                    
                    self.sendMovementData(.up) {
                        self.moveSprite(.up)
                    }
                } else {
                    print("Clicked down")
                    rightButton?.sfSymbolsName = "arrow.down"
                    
                    self.sendMovementData(.down) {
                        self.moveSprite(.down)
                    }
                }
            }
        }
    }
    
    func removeComands(){
        virtualController?.disconnect()
    }
    
}

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

  
