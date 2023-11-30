//
//  SGMovements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func movePlayer(position: CGPoint) {
        let action = SKAction.move(to: position, duration: 0.4)
        
        self.character.run(action)
    }
    
    func play(row: Rows) {
        
        if !isPlayerMoving {
            
            // UPPER BUTTON
            if row == .upper {
                print("DEBUG initial player step: \(step)")
                
                let position = platforms[step % platforms.count].position
                let index = step
                
                print("DEBUG: platform will fall? \(self.fallingOrder[index % self.platforms.count])")
                
                if index >= 8 {
                    print("DEBUG: WON")
                    movePlayer(position: self.childNode(withName: "finishLine")?.position ?? CGPoint(
                        x: viewFrame.maxX,
                        y: viewFrame.midY))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.notify(.gameOver)
                    }
                    return
                } else {
                    movePlayer(position: position)
                    
                    if self.fallingOrder[index % self.platforms.count] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.platforms[index % self.platforms.count].texture = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.notify(.gameOver)
                            }
                            
                            
                            print("DEBUG: DEAD")
                        }
                        
                    } else {
                        step += 2
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.isPlayerMoving = false
                        }
                    }
                }
                
                print("DEBUG final player step: \(step)")
                
                
                // LOWER BUTTON
            } else if row == .lower {
                print("DEBUG initial player step: \(step)")
                
                let position = platforms[(step + 1) % platforms.count].position
                let index = step + 1
                
                print("DEBUG: platform will fall? \(self.fallingOrder[index % self.platforms.count])")
                
                if index >= 8 {
                    print("DEBUG: WON")
                    movePlayer(position: self.childNode(withName: "finishLine")?.position ?? CGPoint(
                        x: viewFrame.maxX,
                        y: viewFrame.midY))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.notify(.gameOver)
                    }
                    return
                } else {
                    movePlayer(position: position)
                    
                    if self.fallingOrder[index % self.platforms.count] {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.platforms[index % self.platforms.count].texture = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.notify(.gameOver)
                            }
                            
                            print("DEBUG: DEAD")
                        }
                        
                    } else {
                        step += 2
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.isPlayerMoving = false
                        }
                    }
                }
                
                print("DEBUG final player step: \(step)")
            }
        }
    }
}

enum Rows: String {
    case upper = "upper"
    case lower = "lower"
}
