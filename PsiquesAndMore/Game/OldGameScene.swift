import Foundation
import GameKit
import SpriteKit

class OldGameScene: SKScene, SKPhysicsContactDelegate {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // personagem
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    let character = SKSpriteNode(imageNamed: "characterLookingRight")
    
    // joystick
    var backJoy = SKSpriteNode(imageNamed: "backgroundJoystick")
    var frontJoy = SKSpriteNode(imageNamed: "frontJoystick")
    var isJoystickBeingUsed: Bool = false
    
    // action Button
    // var actionButton = SKSpriteNode(texture: SKTexture(imageNamed: "frontJoystick"))
  
    // initializers and etc
    let deviceHeight = UIScreen.main.bounds.height
    let playableRect: CGRect
    
    // timer local
    var timerlocal = Timer()
    var controlTimer: Int = 1
    
    // mensagens
    let endMessage = SKSpriteNode(imageNamed: "endOfTheGameCard")
    let button = SKSpriteNode(imageNamed: "tryAgainButton.png")

    override init(size: CGSize){
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMergin = (size.height-playableHeight)/2
        playableRect = CGRect(x: 0, y: playableMergin, width: size.width, height: playableHeight)
        GKAccessPoint.shared.isActive = false
        super.init(size: size)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        // fundo
        let backgroundColorCustom = UIColor(red: 13/255, green: 43/255, blue: 69/255, alpha: 1.0)
        self.backgroundColor = backgroundColorCustom
       
        // funcao para spawnar um obstáculo
        triggerSpawn()
            
        // funcao para comecar o personagem
        trigerCharacter()
        
        // funcao para comecar o joystick
        triggerJoystick()
        
        // colisao? que isso meu chapa
        physicsWorld.contactDelegate = self
        
    } // fim do didMove
    
    func touchDown(atPoint pos : CGPoint) {}
    
    func touchMoved(touch: UITouch) {
        let location = touch.location(in: self)
        
        if isJoystickBeingUsed {
            let vector = CGVector(dx: location.x - backJoy.position.x , dy: location.y - backJoy.position.y)
            
            let angle = atan2(vector.dy, vector.dx)
            
            let distanceFromCenter = CGFloat(backJoy.frame.size.height/2) // originalmente 2
            
            let distanceX = CGFloat(sin(angle - CGFloat(Double.pi/2)) * distanceFromCenter)
            let distanceY = CGFloat(cos(angle - CGFloat(Double.pi/2)) *  distanceFromCenter)
            
            if backJoy.frame.contains(location) {
                frontJoy.position = location
            } else {
                frontJoy.position = CGPoint(x: backJoy.position.x - distanceX, y: backJoy.position.y + distanceY)
            }
            
            velocityX = (frontJoy.position.x - backJoy.position.x) / 8
            velocityY = (frontJoy.position.y - backJoy.position.y) / 8
            updateTexture(angle: angle)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            
            
            if frontJoy.frame.contains(location) {
                isJoystickBeingUsed = true
            } else {
                isJoystickBeingUsed = false
            }
            
            if(touchedNode.name == "restart") {
                restart()
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            self.touchMoved(touch: t)
            
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isJoystickBeingUsed {
            movementOver()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isJoystickBeingUsed {
            movementOver()
        }
    }
    
    // velocidade de movimento
    override func update(_ currentTime: TimeInterval) {
        self.character.position.x += velocityX
        self.character.position.y += velocityY
        
    }
    
    ///
    ///
    ///
    ///
    ///
    /// cria a funcao fantasma
    func triggerSpawn(){
        print("zubumafu")
        /**
         
         if (obstacle.position.y < (self.view?.frame.minY)! ){
             print("uepa")
             repositioning(sknode: obstacle)
         }
         */
        
        // funcao para spawnar um obstáculo
        timerlocal = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            if self.controlTimer == 1 {
                self.spawnObstacle()
            }
            
            
            
        })
    }
    
    // cria o personagem
    func trigerCharacter(){
        // personagem
        let physicsBodyCharacter = SKPhysicsBody(circleOfRadius: 15)
            physicsBodyCharacter.contactTestBitMask = 0x00000001
            physicsBodyCharacter.affectedByGravity = false;
            physicsBodyCharacter.allowsRotation = false
            physicsBodyCharacter.isDynamic = true;
        character.physicsBody = physicsBodyCharacter
        character.name = "character"
        
        self.character.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)! + 200)
        self.addChild(character)
        
        
        //FIXME: rever proporcao mágica, isso vai dar erro!
        let width2 = UIScreen.main.bounds.size.width / 20
        let height2 = UIScreen.main.bounds.size.height / 20
        
        let xRange = SKRange(lowerLimit:0+width2,upperLimit:size.width-width2)
        let yRange = SKRange(lowerLimit:0+height2,upperLimit:size.height-height2)
        
        character.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
    }

    // cria o joystick
    func triggerJoystick(){
        self.backJoy.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)! - 300)
        self.backJoy.zPosition = 1 // quando maior, mais para frente
        self.frontJoy.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)! - 300)
        self.frontJoy.zPosition = 2
        self.addChild(frontJoy)
        self.addChild(backJoy)
    }
    
    ///
    ///
    ///
    ///
    ///
    /// muda a imagem a partir para onde ele está inclinando o joystick
    func updateTexture(angle: CGFloat){
        if angle >= -2.5 && angle < -0.8 {  // olhando para a direta
            let texturaAtualizada = SKTexture(imageNamed: "characterLookingDown")
            //personagem.texture = texturaAtualizada
            character.texture = texturaAtualizada
        }
        else if angle >= -0.8 && angle < 0.5 {  // olhando para a direta
            let texturaAtualizada = SKTexture(imageNamed: "characterLookingRight")
            //personagem.texture = texturaAtualizada
            character.texture = texturaAtualizada
        }
        else if angle >= 0.5 && angle < 2.5 {  // olhando para cima
            let texturaAtualizada = SKTexture(imageNamed: "characterLookingUp")
            //personagem.texture = texturaAtualizada
            character.texture = texturaAtualizada
        }
        else { // olhando p cima
            let texturaAtualizada = SKTexture(imageNamed: "characterLookingLeft")
            //personagem.texture = texturaAtualizada
            character.texture = texturaAtualizada
        }
        
    }
    
    /// controle do joystick
    func movementOver() {
        let moveBack = SKAction.move(to: CGPoint(x: backJoy.position.x, y: backJoy.position.y), duration: TimeInterval(floatLiteral: 0.1))
        
        moveBack.timingMode = .linear
        frontJoy.run(moveBack)
        isJoystickBeingUsed = false
        
        velocityX = 0
        velocityY = 0
    }
    
    
    ///
    ///
    ///
    /// spawna os fantasmas pelo cenário
    func spawnObstacle() {
        print("Spawn")
        
        // fantasma
        let obstacle = SKSpriteNode(imageNamed: "ghost")
        
       // _ = GKShuffledDistribution(lowestValue: 1, highestValue: 3)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 15)
            physicsBody.contactTestBitMask = 0x00000001
            physicsBody.pinned = false
            physicsBody.allowsRotation = false
        obstacle.physicsBody = physicsBody
        obstacle.name = "ghost"
        
        let center = size.width/2.0, difference = CGFloat(85.0)

        obstacle.position = CGPoint(x: CGFloat.random(in: (self.view?.frame.minX)!...(self.view?.frame.maxX)!), y: ((self.view?.frame.maxY)! + 50))   // isso vai dar ruim
        
        addChild(obstacle)
    }
 
    ///
    ///
    ///
    ///
    /// comecou o contato
    func didBegin(_ contact: SKPhysicsContact) {
        print("colidiu?")
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "character" {
            collisionBetween(between: nodeA, object: nodeB)
        } else if nodeB.name == "ghost" {
            collisionBetween(between: nodeB, object: nodeA)
        }
    }
    
    /// o que acontece quando colide
    func collisionBetween(between character: SKNode, object: SKNode){
        print("chegamos na colisao")
        if object.name == "ghost" {
          destroyElements()
          finishedGame()
        } else if object.name == "character" {
            destroyElements()
            finishedGame()
        }
    }
   
    ///
    /// terminou o jogo
    func finishedGame(){
        // controles
       timerlocal.invalidate()
       controlTimer = 0
//       print(controlTimer)
        
       endMessage.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
       endMessage.name = "endMessage"
       addChild(endMessage)
       
       button.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)! - 50)
       button.isUserInteractionEnabled = false // TODO: TALVEZ TROCAR
       button.name = "restart"
       addChild(button)
      
    }
    
    /// destrua tudo
    func destroyElements(){
        print("\n Destruimos a personagem")
        character.removeFromParent()
        backJoy.removeFromParent()
        frontJoy.removeFromParent()
        
        scene?.enumerateChildNodes(withName: "ghost", using: { node, _ in
            node.removeFromParent()
        })
    }
    
    
    
    
    
    /// recomeca o jogo
    func restart(){
//        print("\n Estamos no restart")
        self.endMessage.removeFromParent()
        self.button.removeFromParent()
        
        NotificationCenter.default.post(name: .restartGameNotificationName, object: nil)
        controlTimer = 1
        
        if GKAccessPoint.shared.isActive == false {
            
        } else {
            triggerSpawn()
            trigerCharacter()
            triggerJoystick()
        }
       
        
    }
}
