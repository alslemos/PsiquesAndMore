//
//  GSContactDelegate.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let controle: Int = 3
           guard let nodeA = contact.bodyA.node else { return }
           guard let nodeB = contact.bodyB.node else { return }
            
           if controle != 1 {
               if nodeA.name == "obstacle" {
                   print("nodeB.name == character")
                   collisionBetween(between: nodeA, object: nodeB)
               } else if nodeA.name == "square" {
                   print("nodeB.name == character")
                   collisionBetween(between: nodeB, object: nodeA)
               }
               else if nodeB.name == "obstacle" {
                   print("nodeB.name == ghost")
                   collisionBetween(between: nodeB, object: nodeA)
               }
               else if nodeA.name == "square" {
                   print("nodeA.name == gcharacter")
                   collisionBetween(between: nodeB, object: nodeA)
               }
           } else {
              
           }
       }
    
    
    func collisionBetween(between character: SKNode, object: SKNode){
        print("chegamos na colisao")
        print("chegamos na colisao")
        print("chegamos na colisao")
        print("chegamos na colisao")
        
        if (object.name?.hasPrefix("ghost")) != false  && (character.name == "square"){
            //  retirar a vida
            //  atualizar o status da personagem
            //  dar uma piscadinha na personagem
            
        }
        
        else if object.name == "square" && ((character.name?.hasPrefix("ghost")) != nil) {
            //  retirar a vida
            //  atualizar o status da personagem
            //  dar uma piscadinha na personagem
        }
    }
    
    
}
