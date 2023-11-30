//
//  GSSetupElements.swift
//  PsiquesAndMore
//
//  Created by Arthur Sobrosa on 29/11/23.
//

import Foundation

extension GameScene {
    func setupElements(for game: Game) {
        switch game {
            case .hill:
                setupDownTheHillElements()
            case .squid:
                setupSquidElements()
            case .snake:
                print("foo")
        }
    }
    
    // MARK: - Down the Hill Game
    func setupDownTheHillElements() {
        self.setupFloor()
        self.setupEnemy()
        self.setupRock()
        self.setupTree()
        self.setupAvalanche()
        
        // recicláveis
        self.setupLifeNodes()
        self.setupTimer()
    }
    
    // MARK: - Squid Game
    func setupSquidElements() {
        
    }
}
