import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewFrame: CGRect = CGRect()
    
    var rectangle = SKSpriteNode()

    var square = SKSpriteNode(texture: SKTexture(imageNamed: "animada0"), size: CGSize(width: 60, height: 60))
    
    var entidadeFramesAbaixando: [SKTexture] = []
    var textureAtlassAbaixando = SKTextureAtlas(named: "entidadeAbaixando")
    
    var entidadeFrames: [SKTexture] = []
    var textureAtlasss = SKTextureAtlas(named: "entidadeAnimada")
    
    var characterVelocity: CGFloat = 80
    
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
    
    var gameDuration: Int = 5
    
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
    
    var isPlayerMoving: Bool = false
    var isPlayerTouchingFloor: Bool = false // variável controle que diz se o personagem tá tocando no chão
    
    var snowParticle = SKEmitterNode() // partícula acoplada ao personagem
    
    var lifes: Int = 3 {
        didSet {
            self.updateLifeNodes()
        }
    }
    // n∘ de vidas do personagem
    var lifeNodes = [SKSpriteNode]() // nodos das vidas do personagem
    
    // obstáculos
    
    var spawnObstacleDelay: TimeInterval = 2
    
    // avalanche
    
    var avalanche = SKSpriteNode()
    
    // logica do jogo
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    var players: [Player] = []
    
    var enemiesMovements: [EnemyMovement] = []
    var rocksMovements: [RockMovement] = []
    
    var obstacles: [SKSpriteNode] = []
    var obstaclesOrder: [Obstacle] = []
    
    var startDate: Int = 0
    
    var didGameStart: Bool! {
        didSet {
            self.startGame()
        }
    }
    
    var startGameSubscription: AnyCancellable?
    
    var spawnObstaclesSubscription: AnyCancellable?
    
    var currentEnemyMovement: Int = 0
    var currentRockMovement: Int = 0
    var currentObstacle: Int = 0
    
    var isHost: Bool = false
    
    override func didMove(to view: SKView) {
        match?.delegate = self
        physicsWorld.contactDelegate = self
        
        viewFrame = view.frame
        
        didGameStart = false
    }
    
    func clean() {
        self.removeAllActions()
        self.removeAllChildren()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        spawnObstaclesSubscription?.cancel()
    }
}
