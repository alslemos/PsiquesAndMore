import Foundation
import UIKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let pauseButton = pauseButton {
                if pauseButton.contains(touch.location(in: self)) {
                    sendPauseGameData {
                        self.notifyPauseGame()
                    }
                }
            }
        }
    }
}
