import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewFrame: CGRect = CGRect()
    
    var rectangle = SKSpriteNode()
    
    var characterVelocity: CGFloat = 10
    
    // Don't forget to cancel this afterwards
    var cancellables = Set<AnyCancellable>()
    
    // unicas propriedades que n dá mt para tirar
    var rotationAngle: CGFloat = 0
    var verticalThresholdPoint: CGFloat = 0
    
    var squareYPosition: CGFloat = 0
    var timerLabel = SKLabelNode()
    
    var backgroundSpeed: CGFloat! {
        didSet {
            rectangle.removeAllActions()
            moveBackground()
        }
    }
    
    var gameDuration: Int = 60
    
    var virtualController: GCVirtualController?
    
    // fundo
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // pause button
    var pauseButton: SKSpriteNode?
    
    var isPlayAgainOrderGiven: Bool = false
    var isContinueOrderGiven: Bool = false
    var isGoToMenuOrderGiven: Bool = false
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    var square = SKSpriteNode(imageNamed: "personagem")
    
    // obstáculos
    
    var spawnEnemyDelay: TimeInterval = 2
    var spawnRockDelay: TimeInterval = 2
    
    // logica do jogo
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    var players: [Player] = []
    
    var enemiesMovements: [EnemyMovement] = []
    var enemies: [SKSpriteNode] = []
    var rocksMovements: [RockMovement] = []
    var rocks: [SKSpriteNode] = []
    var startDate: Int = 0
    
    var didGameStart: Bool! {
        didSet {
            self.startGame()
        }
    }
    
    var startGameSubscription: AnyCancellable?
    
    var spawnEnemiesSubscription: AnyCancellable?
    var spawnRocksSubscription: AnyCancellable?
    
    var currentEnemyMovement: Int = 0
    var currentRockMovement: Int = 0
    
    override func didMove(to view: SKView) {
        match?.delegate = self
        physicsWorld.contactDelegate = self
        
        viewFrame = view.frame
        
        didGameStart = false
    }
}
