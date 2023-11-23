import Foundation
import GameKit

extension GameScene {
    
    func submitScore(_ score: Int){
        /// open class func submitScore(_ score: Int, context: Int, player: GKPlayer, leaderboardIDs: [String])
        
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: ["firstLeaderboard"]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
                print("TAZ MANIA") // QUAL A CHANCE DELE OBTER O localplayer? 3
            }
        }
    }
    
    /// Load the player's active achievements.
    func loadAchivements(){
       
        
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let achievementID = "InGh10"
            var achievement: GKAchievement? = nil
            
            // Find an existing achievement.
            achievement = achievements?.first(where: { $0.identifier == achievementID})
            
            // Otherwise, create a new achievement.
            if achievement == nil {
                achievement = GKAchievement(identifier: achievementID)
            }
            
//            // Insert code to report the percentage.
//            if let achievement = GKAchievement(identifier: achievementID) {
//                achievement.percentComplete = 1.0
//                GKAchievement.report([achievement]) { error in
//                    if let error = error {
//                        print("Error in reporting achievements: \(error)")
//                    }
//                }
//            }
            
            
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
        })
    }
}
