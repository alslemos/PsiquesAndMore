//
//  GSContactDelegate.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 09/11/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func collisionBetween(between character: SKNode, object: SKNode){
        print("chegamos na colisao")
        
        if (object.name?.hasPrefix("ghost")) != false  && (character.name == "character"){
            //  retirar a vida
            //  atualizar o status da personagem
            //  dar uma piscadinha na personagem
            
        }
        
        else if object.name == "character" && ((character.name?.hasPrefix("ghost")) != nil) {
            //  retirar a vida
            //  atualizar o status da personagem
            //  dar uma piscadinha na personagem
        }
    }
    
    
}
