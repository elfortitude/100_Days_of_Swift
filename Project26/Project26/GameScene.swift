//
//  GameScene.swift
//  Project26
//
//  Created by out-usacheva-ei on 26.09.2021.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes : UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleportInput = 32
    case teleportOutput = 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score + 1)"
        }
    }
    
    var isGameOver = false
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var teleportOutputPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(level)"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 858, y: 16)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel(level: level)
        createPlayer()
    }
    
//      At the core of the method it loads a level file from disk, then splits it
//      up by line.
//      Each line will become one row of level data on the screen.
    func loadLevel(level: Int) {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Couldn't find level\(level).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Couldn't load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (column * 64) + 32, y: (row * 64) + 32)
                
                if letter == "x" {
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                } else if letter == "v" {
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = "vortex"
                    node.position = position
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    
                    settingPhysics(node: node, categoryBitMask: CollisionTypes.vortex.rawValue, contactTestBitMask: CollisionTypes.player.rawValue)
                } else if letter == "s" {
                    let node = SKSpriteNode(imageNamed: "star")
                    node.name = "star"
                    node.position = position
                    
                    settingPhysics(node: node, categoryBitMask: CollisionTypes.star.rawValue, contactTestBitMask: CollisionTypes.player.rawValue)
                } else if letter == "f" {
                    let node = SKSpriteNode(imageNamed: "finish")
                    node.name = "finish"
                    node.position = position
                    
                    settingPhysics(node: node, categoryBitMask: CollisionTypes.finish.rawValue, contactTestBitMask: CollisionTypes.player.rawValue)
                } else if letter == "i" {
                    let node = SKSpriteNode(imageNamed: "teleport")
                    node.name = "teleportInput"
                    node.position = position
                    
                    settingPhysics(node: node, categoryBitMask: CollisionTypes.teleportInput.rawValue, contactTestBitMask: CollisionTypes.player.rawValue)
                } else if letter == "o" {
                    let node = SKSpriteNode(imageNamed: "teleport")
                    node.name = "teleportOutput"
                    node.position = position
                    teleportOutputPosition = position
                    
                    settingPhysics(node: node, categoryBitMask: CollisionTypes.teleportOutput.rawValue, contactTestBitMask: CollisionTypes.player.rawValue)
                } else if letter == " " {
                    
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
//        createPlayer()
    }
    
    func settingPhysics(node: SKSpriteNode, categoryBitMask: UInt32, contactTestBitMask: UInt32) {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = categoryBitMask
        node.physicsBody?.contactTestBitMask = contactTestBitMask
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func createPlayer(position: CGPoint = CGPoint(x: 96, y: 672)) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            player.physicsBody?.isDynamic = false
            player.removeFromParent()
            removeAllChildren()
            score = 0
            
            level += 1
            didMove(to: self.view!)
        } else if node.name == "teleportInput" {
            player.physicsBody?.isDynamic = false
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                if let teleportOutputPosition = self?.teleportOutputPosition {
                    self?.player.physicsBody?.isDynamic = false
                    self?.createPlayer(position: teleportOutputPosition)
                }
            }
        }
    }
    
//      Called when two bodies first contact each other.
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
}
