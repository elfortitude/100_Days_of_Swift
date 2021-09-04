//
//  Target.swift
//  Milestone_Projects16-18
//
//  Created by out-usacheva-ei on 05.09.2021.
//

import UIKit
import SpriteKit

class Target: SKNode {

    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    
    var isHit = false
    
    func configure() {
        let targetType = Int.random(in: 0...3)
        let stickType = Int.random(in: 0...2)
        
        target = SKSpriteNode(imageNamed: "target\(targetType)")
        stick = SKSpriteNode(imageNamed: "stick\(stickType)")
        
        target.name = "target"
        target.position.y += 116
        
        addChild(target)
        addChild(stick)
    }
    
    func hit() {
        isHit = true
        removeAllActions()
        target.name = nil
        
        let animationTime = 0.2
        target.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
        stick.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
        run(SKAction.fadeOut(withDuration: animationTime))
        run(SKAction.moveBy(x: 0, y: -30, duration: animationTime))
        run(SKAction.scaleX(by: 0.8, y: 0.7, duration: animationTime))
    }
}
