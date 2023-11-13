//
//  GSSetupAchievements.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import GameKit
import SpriteKit

extension GameScene {
    func reportAchievementsForGameState(hasWon: Bool) {
        
        //1
        var achievements = [GKAchievement]()
        //2
        achievements.append(AchievementsHelper.detectVipAchievement(noOfCollisions: 4 )) // mudar essa variável
        //3
        if hasWon {
            achievements.append(AchievementsHelper.detectVipAchievement(noOfCollisions: 4))
        }
        //4
        
        // MatchManager().sharedInstance.reportAchievements(achievements)
        // VERFICAR
    }
}
