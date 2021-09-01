//
//  GameScene.swift
//  Project 17
//
//  Created by out-usacheva-ei on 30.08.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var possibleElements = ["ball", "hammer", "tv"]
    var enemyCount = 0
    var time: TimeInterval = 1
    var isGameOver = false
    var gameTimer: Timer?
    
//      For stopping the player from cheating by lifting their finger and tapping elsewhere.
    var lastLocation: CGPoint?
    
//      Like viewDidLoad in UIKit.
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: 1024, y: 384)
//      We’re going to ask SpriteKit to simulate 10 seconds passing in the emitter, thus
//      updating all the particles as if they were created 10 seconds ago. This will have
//      the effect of filling our screen with star particles.
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        lastLocation = player.position
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleElements.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        enemyCount += 1
        if enemyCount >= 5 {
            enemyCount = 0
            if time > 0.3 {
                time -= 0.1
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
//      For stopping the player from cheating by lifting their finger and tapping elsewhere.
        if ((location.x >= lastLocation!.x - player.size.width / 2) && (location.x <= lastLocation!.x + player.size.width / 2)) && ((location.y >= lastLocation!.y - player.size.height / 2) && (location.y <= lastLocation!.y + player.size.height / 2)) {
            player.position = location
            lastLocation = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
//      For stopping the player from cheating by lifting their finger and tapping elsewhere.
        if ((location.x >= player.position.x - player.size.width / 2) && (location.x <= player.position.x + player.size.width / 2)) && ((location.y >= player.position.y - player.size.height / 2) && (location.y <= player.position.y + player.size.height / 2)) {
            lastLocation = location
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        gameTimer?.invalidate()
        
        isGameOver = true
    }
    
}
