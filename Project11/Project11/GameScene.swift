import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            if balls == 0 {
                editLabel.text = "Retry"
                gameOverLabel.alpha = 1
            } else {
                editLabel.text = editingMode ? "Done" : "Edit"
                gameOverLabel.alpha = 0
            }
        }
    }
    
    var ballsLabel: SKLabelNode!
    var balls = 5 {
        didSet {
            ballsLabel.text = "Balls: \(balls)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var gameOverLabel: SKLabelNode!
    
    let colors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: 5"
        ballsLabel.horizontalAlignmentMode = .center
        ballsLabel.position = CGPoint(x: 512, y: 700)
        addChild(ballsLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.numberOfLines = 2
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.alpha = 0
        addChild(gameOverLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)

            if objects.contains(editLabel){
                editLabelToggle()
            } else if editingMode {
                
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box"

                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false

                addChild(box)
                
            } else if balls > 0 {
                if location.y < 700{
                    makeBall(at: CGPoint(x: location.x, y: 700))
                } else {
                    makeBall(at: location)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeBall(at position: CGPoint){
        let imageName = "ball\(colors.randomElement()!)"
        let ball = SKSpriteNode(imageNamed: imageName)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4
        ball.position = position
        ball.name = "ball"
        
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        
        balls -= 1
        addChild(ball)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
         var slotGlow: SKSpriteNode

         if isGood {
             slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
             slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
             slotBase.name = "good"
         } else {
             slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
             slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
             slotBase.name = "bad"
         }

         slotBase.position = position
         slotGlow.position = position
        
        let spin = SKAction.rotate(byAngle: -(.pi), duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)

        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    func editLabelToggle(){
        if balls > 0 {
            editingMode.toggle()
        } else {
            balls = 5
            score = 0
            gameOverLabel.alpha = 0
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            balls += 1
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            destroy(ball: object)
            score += 1
        }
    }

    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
}
