import Combine
import GameController
import GameKit
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var rectangle = SKSpriteNode()
    
    var characterVelocity: Int = 0
    
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
    
    var gameDuration: Int = 10
    
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
    
    var obstacle = SKSpriteNode()
    let spawnObstacleDelay: TimeInterval = 2
    
    // logica do jogo
    var matchManager: MatchManager?
    
    var match: GKMatch?
    
    var gameModel: GameModel! {
        didSet {
            updateUI()
        }
    }
    
    var isControlSet: Bool = false
    
    var controls: [String]! {
        didSet {
            updateUI()
        }
    }
    
    var areControlNodesSet: Bool = false
    
    var localPlayerIndex: Int?
    var remotePlayerIndex: Int?
    
    var obstaclesMovements: [ObstacleMovement] = []
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        match?.delegate = self
        
        self.setupPauseButton()
        self.setupCharacter()
        self.setupFloor()
        self.setupBackground()
        
        self.backgroundSpeed = 0
        self.createSubscriptions()
        self.savePlayers()
        
        self.triggerTimer()
    }
    
    // MARK: - Combine functions
    private func createSubscriptions() {
        backgroundPositionUpdater()
        velocityUpdater()
    }
    
    func obstacleSpawner() {
        print("DEBUG: inside obstacleSpawner")
        
        let timer = Timer.publish(every: self.spawnObstacleDelay, on: .main, in: .common)
            .autoconnect()
        
        let subscription = timer
        
        var lastObstacleMovement: Int = 0
        
        subscription
            .scan(-1) { count, _ in
                if !self.isPaused {
                    lastObstacleMovement = count

                    return count + 1
                } else {
                    return count
                }
            }
            .sink { count in
                print("obstacle counter: \(count)")
                
                print("last obstacle counter: \(lastObstacleMovement)")
                
                if (count < (self.gameDuration / Int(self.spawnObstacleDelay)) && count != lastObstacleMovement) {
                    let obstacleMovement = self.obstaclesMovements[count]
                    
                    self.setupObstacle {
                        self.moveObstacle(obstacleMovement: obstacleMovement) {
                            if let child = self.childNode(withName: "obstacle") as? SKSpriteNode {
                                child.removeFromParent()
                            }
                        }
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func backgroundPositionUpdater() {
        guard let view = self.view else { return }
        
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .map { _ in
                return self.rectangle.position
            }
            .sink { position in
                if position.x <= -(view.frame.width) {
                    self.rectangle.position = CGPoint(x: 0, y: self.verticalThresholdPoint)
                }
            }.store(in: &cancellables)
    }
    
    private func velocityUpdater() {
        let publisher = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { _ in
                self.backgroundSpeed += 1
            }.store(in: &cancellables)
    }
    
    func notifyPauseGame() {
        NotificationCenter.default.post(name: .pauseGameNotificationName, object: nil)
        print("DEBUG: pause game")
    }
    
    func sendPauseGameData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("pauseGame") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send pause game data failed")
        }
    }
    
    func notifyContinueGame() {
        NotificationCenter.default.post(name: .continueGameNotificationName, object: nil)
        print("DEBUG: continue game")
    }
    
    func sendContinueGameData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("continueGame") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send continue game data failed")
        }
    }
    
    func notifyGoToMenu() {
        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
        print("DEBUG: go to menu")
    }
    
    func sendGoToMenuData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("goToMenu") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send back to menu data failed")
        }
    }
    
    func notifyGameOver() {
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
        print("DEBUG: game over")
    }
    
    func sendGameOverData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("gameOver") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send game over data failed")
        }
    }
    
    func notifyPlayAgain() {
        NotificationCenter.default.post(name: .playAgainGameNotificationName, object: nil)
        print("DEBUG: play again")
    }
    
    func sendPlayAgainData(_ completion: @escaping () -> ()) {
        do {
            guard let data = try? JSONEncoder().encode("playAgain") else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("send play again data failed")
        }
    }
    
    func gameOver(_ completion: @escaping () -> ()) {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        rectangle.removeFromParent()
        backgroundImage.removeFromParent()
        timerLabel.removeFromParent()
        pauseButton?.removeFromParent()
        removeComands()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        completion()
    }
    
    func restartGame() {
        self.gameOver {
            self.setupPauseButton()
            self.setupCharacter()
            self.setupFloor()
            self.setupBackground()
            
            self.backgroundSpeed = 0
            self.createSubscriptions()
            self.savePlayers()
            
            self.triggerTimer()
        }
    }

    func checkMovement(for control: Int, with playerIndex: Int) {
        if self.gameModel.players[playerIndex].movements == .downAndRight {
            if control == 1 {
                self.moveSpriteRight()
            } else {
                self.moveSpriteDown()
            }
        } else {
            if control == 1 {
                self.moveSpriteLeft()
            } else {
                self.moveSpriteUP()
            }
        }
    }
    
    func savePlayers() {
        guard let remotePlayerName = match?.players.first?.displayName else { return }
        
        let localPlayer = Player(displayName: GKLocalPlayer.local.displayName, movements: .upAndLeft)
        let remotePlayer = Player(displayName: remotePlayerName, movements: .downAndRight)
        
        var players = [localPlayer, remotePlayer]
        players.sort { (localPlayer, remotePlayer) -> Bool in
            localPlayer.displayName < remotePlayer.displayName
        }
        
        self.localPlayerIndex = players.firstIndex { $0.displayName == localPlayer.displayName }
        self.remotePlayerIndex = players.firstIndex { $0.displayName == remotePlayer.displayName }
        
        self.gameModel.players = players
        
        if let index = localPlayerIndex {
            if index == 0 {
                print("sou o player principal")
                let movements = setMovementsForPlayer()
                gameModel.players[0].movements = movements[0]
                gameModel.players[1].movements = movements[1]
                
                sendData {
                    print("sending game model data")
                    self.saveControls()
                    
                    print("triggering commands")
                    self.setupCommands()
                    
                    print("creating obstacles array")
                    self.createObstaclesArray {
                        self.obstacleSpawner()
                    }
                }
            }
        }
    }
    
    private func setMovementsForPlayer() -> [Movements] {
        var allMovements: [Movements] = Movements.allCases
        var localPlayerMovements: Movements = .upAndLeft
        var remotePlayerMovements: Movements = .downAndRight
        
        guard let movements = allMovements.randomElement() else { return [] }
        localPlayerMovements = movements
        
        guard let index = (allMovements.firstIndex { $0 == localPlayerMovements }) else { return [] }
        allMovements.remove(at: index)
        
        remotePlayerMovements = allMovements[0]
        
        print("my movements: \(localPlayerMovements)")
        print("his movements: \(remotePlayerMovements)")
        
        return [localPlayerMovements, remotePlayerMovements]
    }
    
    private func saveControls() {
        print("saving controls")
        guard let index = localPlayerIndex else { return }
        
        if gameModel.players[index].movements == .downAndRight {
            sendControlsData(.upAndLeft)
        } else {
            sendControlsData(.downAndRight)
        }
    }
    
    private func sendControlsData(_ movements: Movements) {
        print("sending controls data")
        do {
            guard let data = try? JSONEncoder().encode(movements) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send controllers data failed")
        }
    }
    
    private func updateUI() {
        guard self.gameModel.players.count >= 2 else { return }
        
        if let controls = self.controls, controls.count >= 2 {
            if !areControlNodesSet {
                //                setControlNodes()
                areControlNodesSet = false
            }
        }
        
        guard let remoteIndex = remotePlayerIndex else { return }
        
        if gameModel.players[remoteIndex].didMoveControl1 {
            gameModel.players[remoteIndex].didMoveControl1 = false
            
            sendData {
                self.checkMovement(for: 1, with: remoteIndex)
            }
        } else if gameModel.players[remoteIndex].didMoveControl2 {
            gameModel.players[remoteIndex].didMoveControl2 = false
            
            sendData {
                self.checkMovement(for: 2, with: remoteIndex)
            }
        }
    }
    
     func sendData(completion: @escaping (() -> Void)) {
        guard let match = match else { return }
        
        do {
            guard let data = self.gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
            completion()
        } catch {
            print("Send data failed")
        }
    }
}
