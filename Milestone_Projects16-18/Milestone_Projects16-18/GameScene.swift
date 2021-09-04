//
//  GameScene.swift
//  Milestone_Projects16-18
//
//  Created by out-usacheva-ei on 02.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletSprite: SKSpriteNode!
    var bulletTextures = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3")
    ]
    var showBullets = 3 {
        didSet {
            bulletSprite.texture = bulletTextures[showBullets]
        }
    }
    
    var isGameOver = false
    
    var targetSpeed = 4.0
    var targetDelay = 0.8
    var targetsCreated = 0
    
//      Like viewDidLoad in UIKit.
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.blendMode = .replace
        background.zPosition = -2
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 512, y: 384)
        grass.size.width = self.size.width
        grass.zPosition = -1
        addChild(grass)
        
        let backWater = SKSpriteNode(imageNamed: "water-bg")
        backWater.position = CGPoint(x: 512, y: 230)
        backWater.size.width = self.size.width
        backWater.zPosition = 1
        addChild(backWater)
        
        let frontWater = SKSpriteNode(imageNamed: "water-fg")
        frontWater.position = CGPoint(x: 512, y: 160)
        frontWater.size.width = self.size.width
        frontWater.zPosition = 3
        addChild(frontWater)
        
        animate(backWater, distance: 8, duration: 1.3)
        animate(frontWater, distance: 12, duration: 1)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.size.width = self.size.width
        curtains.size.height = self.size.height
        curtains.zPosition = 5
        addChild(curtains)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 730, y: 70)
        scoreLabel.zPosition = 6
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        bulletSprite = SKSpriteNode(texture: bulletTextures[3])
        bulletSprite.position = CGPoint(x: 180, y: 90)
        bulletSprite.xScale = 1.5
        bulletSprite.yScale = 1.5
        bulletSprite.zPosition = 6
        addChild(bulletSprite)
        
        levelUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            if let newGame = SKScene(fileNamed: "GameScene") {
                let transition = SKTransition.doorway(withDuration: 1)
                view?.presentScene(newGame, transition: transition)
            }
        } else {
            if showBullets > 0 {
                run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
                showBullets -= 1
                
                guard let touch = touches.first else { return }
                let location = touch.location(in: self)
                let tappedNodes = nodes(at: location).filter { node in
                    node.name == "target"
                }
                
                guard let tappedNode = tappedNodes.first else { return }
                guard let parentNode = tappedNode.parent as? Target else { return }
                
                parentNode.hit()
                
                score += 3
            } else {
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
                gameOver()
            }
        }
    }
    
    func animate(_ node: SKSpriteNode, distance: CGFloat, duration: TimeInterval) {
        let movementUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
        let movemenDown = movementUp.reversed()
        let sequence = SKAction.sequence([movementUp, movemenDown])
        let repeatForever = SKAction.repeatForever(sequence)
        node.run(repeatForever)
    }
    
    func levelUp() {
        targetSpeed *= 0.99
        targetDelay *= 0.99
        targetsCreated += 1
        
        if targetsCreated < 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + targetDelay) { [weak self] in
                self?.createTarget()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.gameOver()
            }
        }
    }
    
    func createTarget() {
        let target = Target()
        target.configure()
        
        let level = Int.random(in: 0...2)
        var movingRight = true
        
        switch level {
        case 0:
//      In front of the grass.
            target.zPosition = 0
            target.position.y = 320
//            target.setScale(0.7)
        case 1:
//      In front of the water background.
            target.zPosition = 2
            target.position.y = 220
            target.setScale(1.15)
            movingRight = false
        default:
//      In front of the water foreground.
            target.zPosition = 4
            target.position.y = 130
            target.setScale(1.25)
        }
        
        let move: SKAction
        
        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 1024, duration: targetSpeed)
        } else {
            target.position.x = 1024
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: targetSpeed)
        }
        
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        target.run(sequence)
        addChild(target)
        
        levelUp()
    }
    
    func gameOver() {
        isGameOver = true
        
        let gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.alpha = 0
        gameOver.setScale(2)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let group = SKAction.group([fadeIn, scaleDown])
        
        gameOver.run(group)
        gameOver.zPosition = 6
        addChild(gameOver)
    }
    
}
