import Foundation
import GameKit

struct EndOfTheGame {
    
    func updateAchievements() {
        var achievements: [GKAchievement] = []
        achievements.append(AchievementsHelper.firstWinAchievement(didWin: true))
        GameKitHelper.shared.reportAchievements(achievements: achievements)
        
    }
    
}
