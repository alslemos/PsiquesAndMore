import SwiftUI
import GameController
import GameKit
import SpriteKit
import Combine


class GameScene: SKScene {
    var rectangle = SKSpriteNode()
    
    // Don't forget to cancel this afterwards
    private var cancellables = Set<AnyCancellable>()
    
    // unica propriedade que n dá mt para tirar
    var rotationAngle: CGFloat = 0
    
    var squareYPosition: CGFloat = 0
    
    var backgroundSpeed: CGFloat! {
        didSet {
            rectangle.removeAllActions()
            moveBackground()
        }
    }
    
    var gameDuration: Int = 60
    
    var virtualController: GCVirtualController?
    
    // fundo
    private var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    // pause button
    var pauseButton: SKSpriteNode?
    
    var isGamePaused: Bool = false
    
    var isGoToMenuOrderGiven: Bool = false
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    var square = SKSpriteNode()
    
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
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        match?.delegate = self
        
        
        // inicializacao dos elementos
        setupPauseButton()
        setupCharacter()
        setupFloor()
        setupCommands()

        
        backgroundSpeed = 0   // isso aqui tem chance de dar ruim
        createSubscriptions()
        savePlayers()
    }
    
   
    
    // MARK: - Combine functions
    private func createSubscriptions() {
        backgroundPositionUpdater()
        velocityUpdater()
        timerTracker()
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
                if position.x <= 0 {
                    self.rectangle.position = CGPoint(x: view.frame.width, y: 0)
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
    
    private func timerTracker() {
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        let subscription = publisher
        
        subscription
            .scan(0) { count, _ in
                return count + 1
            }
            .sink { count in
                if count >= self.gameDuration {
                    print("time's up")
                    // perform game over
                }
            }.store(in: &cancellables)
    }
    
    func notifyPausedState(for order: OrderGiven, _ completion: @escaping (() -> Void)) {
        if order == .pauseGame {
            self.isGamePaused = true
            
            NotificationCenter.default.post(name: .pauseGameNotificationName, object: nil)
            print("DEBUG: pause game")
            completion()
        } else {
            self.isGamePaused = false
            
            NotificationCenter.default.post(name: .continueGameNotificationName, object: nil)
            print("DEBUG: continue game")
            completion()
        }
    }
    
    func sendPausedStateData() {
        do {
            guard let data = try? JSONEncoder().encode(self.isGamePaused) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send paused state data failed")
        }
    }
    
    private func notifyGoToMenu() {
        NotificationCenter.default.post(name: .goToMenuGameNotificationName, object: nil)
        print("DEBUG: go to menu")
    }
    
    func sendGoToMenuData() {
        do {
            guard let data = try? JSONEncoder().encode(OrderGiven.goToMenu) else { return }
            try self.match?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send back to menu data failed")
        }
    }
    
    // removendo os comandos da tela
    func removeComands(){
        virtualController?.disconnect()
    }
    
    // fim de jogo
    func gameOver() {
        guard let scene = self.scene else { return }
        
        scene.removeAllActions()
        square.removeFromParent()
        rectangle.removeFromParent()
        backgroundImage.removeFromParent()
        removeComands()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
    }

    
    private func checkMovement(for control: Int, with playerIndex: Int) {
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
    
    private func savePlayers() {
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

extension GameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        // Check if it's the game model data
        if let model = GameModel.decode(data: data) {
            gameModel = model
        }
        
        // Check if it's the controls data
        if let controls = try? JSONDecoder().decode(Movements.self, from: data) {
            guard let localIndex = localPlayerIndex else { return }
            gameModel.players[localIndex].movements = controls
            self.setupCommands()
        }
        
        // Check if it's the paused state data
        if let pausedState = try? JSONDecoder().decode(Bool.self, from: data) {
            print("paused state data received")
            if pausedState {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .pauseGame) {
                    print("Notifying...")
                }
            } else {
                self.isGamePaused = pausedState
                
                notifyPausedState(for: .continueGame) {
                    print("Notifying...")
                }
            }
        }
        
        // Check if it's the go to menu data
        if let goToMenu = try? JSONDecoder().decode(OrderGiven.self, from: data) {
            print("back to menu data received")
            if goToMenu == .goToMenu {
                self.isGoToMenuOrderGiven = true
                self.notifyGoToMenu()
            }
        }
    }
}
