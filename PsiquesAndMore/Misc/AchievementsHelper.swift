//
//  AchievementsHelper.swift
//  PsiquesAndMore
//
//  Created by Alexandre Lemos da Silva on 13/11/23.
//

import Foundation
import SwiftUI
import GameKit

class AchievementsHelper {
    
    struct Constants {
        static let tempoJogo = 1
        static let vipAchievement = "grp.vipAchievement"
        
    }
    
    class func detectVipAchievement(noOfCollisions: Int) -> GKAchievement {
    //1
    let percent = (noOfCollisions / Constants.tempoJogo) * 100
        
    //2
    let collisionAchievement = GKAchievement(identifier: Constants.vipAchievement)
        
    //3
    collisionAchievement.percentComplete = 100     // calcula
    collisionAchievement.showsCompletionBanner = true   // mostra na tela
        
    return collisionAchievement
        
    } 
}

/**
 2. You create a GKAchievement object using the Destruction Hero achievement identifier.
 3. You set the percentComplete property of the GKAchievement object to the one calculated in the first step.
 
 
 */
