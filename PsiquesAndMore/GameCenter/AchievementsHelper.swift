//
//  AchievementsHelper.swift
//  CandlesAndTombs
//
//  Created by Alexandre Lemos da Silva on 22/11/23.
//

import Foundation
import GameKit



class AchievementsHelper {
    static let achievementIdFirstWin = "InGh10"
    
    class func firstWinAchievement(didWin: Bool) -> GKAchievement { let achievement = GKAchievement(
        identifier: AchievementsHelper.achievementIdFirstWin)
        if didWin {
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
        }
        return achievement
    }
}


