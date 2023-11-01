//
//  GameViewController.swift
//  MovementBackground
//
//  Created by Arthur Sobrosa on 31/10/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0, y: 0)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
}
