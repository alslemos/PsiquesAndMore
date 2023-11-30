//
//  SGRandomElements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func createFallingOrderArray() {
        for _ in 0..<4 {
            let willFall = Bool.random()
            self.fallingOrder.append(willFall)
            self.fallingOrder.append(!willFall)
        }
    }
}
