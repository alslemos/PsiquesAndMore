//
//  SGRounds.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func checkRound() {
        print("checking round")
        
        if step == 0 || step == 4 {
            if isHost {
                isItMyTurn = true
            } else {
                isItMyTurn = false
            }
            
            matchManager?.myTurn = isItMyTurn
            
            notify(.yourTurn)
        } else if step == 2 || step == 6 {
            if isHost {
                isItMyTurn = false
            } else {
                isItMyTurn = true
            }
            
            matchManager?.myTurn = isItMyTurn
            
            notify(.yourTurn)
        } else {
            // you win!
//            play(row: .upper)
        }
        
        print("foo: my turn: \(isItMyTurn)")
    }
    
    func checkWillFall() {
        
    }
}
