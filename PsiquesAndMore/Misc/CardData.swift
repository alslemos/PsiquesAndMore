import Foundation
import SwiftUI
import SpriteKit

enum Categories: String, CaseIterable, Identifiable {   // << type !!
    var id: Self { self }
    
    case OnePlayer, TwoPlayers, ThreePlayers, UntiThreePlayers   // << known variants
    
    var retorno: some Any { // corresponding view !!
        switch self {
        case .OnePlayer:
            return "One player"
            
        case .TwoPlayers:
            return "For two players"
            
        case .ThreePlayers:
            return "Three players"
            
        case .UntiThreePlayers:
            return "Until three players!"
        }
    }
    
}

struct GameCardModel {
    var title: String
    var demoImage: String?
    var isAvaible: Bool
    var amountOfPlayers: Categories
    var gamelink: String?
}

extension GameCardModel {
    
    static let sampleData: [GameCardModel] = [  //   static let sampleData: [DailyScrum] =
        GameCardModel(title: "Down the hill",
                      demoImage: "PreviewDownTheHill",
                      isAvaible: true,
                      amountOfPlayers: .TwoPlayers,
                      gamelink: "")
    
    ]
}
