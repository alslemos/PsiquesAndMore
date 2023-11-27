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

extension MatchManager {
    func reportScore(score: Int, forLeaderboardID leaderboardID: String, errorHandler: ((Error?) -> Void)? = nil) {
        guard self.localPlayer.isAuthenticated else { return }
        
        if #available(iOS 14, *) {
            GKLeaderboard.submitScore(score, context: 0, player: self.localPlayer, leaderboardIDs: [leaderboardID]) { error in
                print("error: \(String(describing: error))")
            }
        } else {
            let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
            gkScore.value = Int64(score)
            GKScore.report([gkScore], withCompletionHandler: errorHandler)
        }
    }
    
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((Error?)->Void)? = nil) {
        guard localPlayer.isAuthenticated else { return }
        
        GKAchievement.report(achievements, withCompletionHandler: errorHandler)
    }
}
