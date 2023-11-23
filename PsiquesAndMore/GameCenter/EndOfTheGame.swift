//
//  EndOfTheGame.swift
//  CandlesAndTombs
//
//  Created by Alexandre Lemos da Silva on 23/11/23.
//

import Foundation
import GameKit

struct EndOfTheGame {
    
    func updateAchievements(){
        var isWinner: Bool = true
        
        var achievements: [GKAchievement] = []
        achievements.append(AchievementsHelper.firstWinAchievement(didWin: isWinner))
        GameKitHelper.shared.reportAchievements(achievements: achievements)
        
    }
    
}
