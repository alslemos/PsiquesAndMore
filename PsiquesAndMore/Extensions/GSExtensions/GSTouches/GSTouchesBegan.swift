import Foundation
import UIKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let pauseButton = pauseButton {
                if pauseButton.contains(touch.location(in: self)) {
                    sendNotificationData(.pauseGame)
                    notify(.pauseGame)
                }
            }
            
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            for node in touchedNodes {
                if isItMyTurn {
                    if node.name == "upperButton" {
                        sendStepData(Rows.upper.rawValue) {
                            self.play(row: .upper)
                        }
                    } else if node.name == "lowerButton" {
                        sendStepData(Rows.lower.rawValue) {
                            self.play(row: .lower)
                        }
                    }
                }
                
                if node.name == "backButton" {
                    
                    notify(.goToMenu)
                }
            }
        }
    }
}
