import Foundation
import GameKit

extension GameScene {
    func sendResults() {
        let score = computePoints()
        
        submitScore(score)
                
        var achievements: [GKAchievement] = []
        achievements.append(AchievementsHelper.firstWinAchievement(didWin: true))
        matchManager?.reportAchievements(achievements: achievements)
    }
    
    func computePoints() -> Int {
        var result = Int((self.timeCounter * 100) / 60)
        result += (self.lifes * 10)
        
        return result
    }
    
    func submitScore(_ score: Int) {
        /// open class func submitScore(_ score: Int, context: Int, player: GKPlayer, leaderboardIDs: [String])
        guard let localPlayer = matchManager?.localPlayer else { return }
        
        GKLeaderboard.submitScore(score, context: 0, player: localPlayer, leaderboardIDs: [MatchManager.leaderBoardID]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
                print("TAZ MANIA") // QUAL A CHANCE DELE OBTER O localplayer? 3
            }
        }
    }
    
    /// Load the player's active achievements.
    func loadAchivements() {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let achievementID = "InGh10"
            var achievement: GKAchievement? = nil
            
            // Find an existing achievement.
            achievement = achievements?.first(where: { $0.identifier == achievementID})
            
            // Otherwise, create a new achievement.
            if achievement == nil {
                achievement = GKAchievement(identifier: achievementID)
            }
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
        })
    }
}
