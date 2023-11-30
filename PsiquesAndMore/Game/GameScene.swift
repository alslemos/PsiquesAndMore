import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Just for Squid Game
    var platforms: [SKSpriteNode] = []
    var fallingOrder: [Bool] = []
    var step: Int = 0 {
        didSet {
            if selectedGame == .squid {
                print("checking round")
                self.checkRound()
            }
        }
    }
    
    var isItMyTurn: Bool = false
    
    // MARK: - Floor
    
    // node
    var rectangle = SKSpriteNode()
    
    // position
    var rotationAngle: CGFloat = 0
    var verticalThresholdPoint: CGFloat = 0
    
    // movement
    var floorSpeed: CGFloat! {
        didSet {
            rectangle.removeAllActions()
            floorMovement()
        }
    }
    
    // MARK: - Character
    
    // node
    var character = SKSpriteNode() // reciclavel
    
    // position
    var characterYPosition: CGFloat = 0
    
    // velocity
    var characterVelocity: CGFloat = 20
    
    // movement
    var isPlayerMoving: Bool = false
    var isPlayerTouchingFloor: Bool = false
    var movementDelay: TimeInterval = 0.5
    var movementImpulse: CGFloat = 10
    
    // particle
    var snowParticle = SKEmitterNode()
    
    // Animations
    var loweredEntityFrames: [SKTexture] = []
    var loweredTextureAtlas = SKTextureAtlas(named: "loweredEntity")
    
    var animatedEntityFrames: [SKTexture] = []
    var animatedTextureAtlas = SKTextureAtlas(named: "animatedEntity")
    
    // MARK: - Lifes
    
    // nodes
    var lifeNodes = [SKSpriteNode]()
    
    // life updater
    var lifes: Int = 3 {
        didSet {
            self.updateLifeNodes()
            
            if isHost {
                if self.lifes <= 0 {
                    self.sendInstaKillData()
                } else {
                    self.sendLifeData()
                }
            }
        }
    }
    
    // character doesn't lose lifes when is invincible
    var isPlayerInvincible: Bool = false {
        didSet {
            if isPlayerInvincible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isPlayerInvincible = false
                    print("DEBUG: invincible? : \(self.isPlayerInvincible)")
                }
            }
        }
    }
    
    // MARK: - Obstacles
    
    // enemy
    let enemy = SKSpriteNode(texture: Textures.birdTexture, size: CGSize(width: 30, height: 30))
    
    // rock
    let rock = SKSpriteNode(texture: Textures.rockTexture, size: CGSize(width: 40, height: 30))
    var isRockFalling: Bool = false
    
    // tree
    let tree = SKSpriteNode(texture: Textures.trunkTexture, size: CGSize(width: 25, height: 50))
    
    // delay to spawn an obstacle
    var spawnObstacleDelay: TimeInterval = 4
    
    // store different movements for enemies
    var enemiesMovements: [EnemyMovement] = []
    var currentEnemyMovement: Int = 0
    
    // store different obstacles to be spawned
    var obstaclesOrder: [Obstacle] = []
    var currentObstacle: Int = 0
    
    // MARK: - Avalanche
    var avalanche = SKSpriteNode(texture: SKTexture(imageNamed: "avalanche0"))
    
    // MARK: - Game time
    var gameDuration: Int = 60
    
    var timeCounter: Int = 0
    
    var timerLabel = SKLabelNode()
    
    var startDate: Int = 0
    
    // MARK: - Game Setup
    
    // game chosen
    var selectedGame: Game = .hill
    
    // game rect
    var viewFrame: CGRect = CGRect()
    
    // players indexes
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    // store players
    var players: [Player] = []
    
    // store host player
    var isHost: Bool = false
    
    // MARK: - Game State
    
    // starting game
    var didGameStart: Bool! {
        didSet {
            self.startGame()
        }
    }
    
    // pause button
    var pauseButton: SKSpriteNode?
    
    var isPlayAgainOrderGiven: Bool = false
    var isContinueOrderGiven: Bool = false
    var isGoToMenuOrderGiven: Bool = false
    
    // MARK: - Match
    var matchManager: MatchManager?
    var match: GKMatch?
    
    // MARK: - Controller
    var virtualController: GCVirtualController?
    
    // MARK: - Subscriptions
    
    // general subscriptions
    var cancellables = Set<AnyCancellable>()
    
    // obstacle subscription
    var spawnObstaclesSubscription: AnyCancellable?
    
    // game starter subscription
    var startGameSubscription: AnyCancellable?
    
    // MARK: - Main functions
    override func didMove(to view: SKView) {
        guard let game = matchManager?.selectedGame else { return }
        selectedGame = game
        
        match?.delegate = self
        physicsWorld.contactDelegate = self
        
        viewFrame = view.frame
        
        didGameStart = false
    }
}
