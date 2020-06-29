//
//  junk.swift
//  AstroJunk
//
//  Created by Mondale on 6/9/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

enum JunkType: String, CaseIterable {
    case redWing = "wingRed"
    case greenWing = "wingGreen"
    case beam = "beam"
}

class Junk: SKSpriteNode{
    
    init(){
        let randomTexture = JunkType.allCases.randomElement()!
        let texture = SKTexture(imageNamed: randomTexture.rawValue)
        let color = UIColor.clear
        var size = CGSize(width: 40, height: 40)
        if randomTexture.rawValue == "beam"{
            size = CGSize(width: 40, height: 40)
        }
        
        super.init(texture: texture, color: color, size: size)
        self.name = "junk"
        self.zPosition = 2
        
        //Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
                self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Junk
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveJunk(scene: SKScene){
        if let view = scene.view{
            position.x = CGFloat.random(in: 0...view.bounds.width)
            position.y = view.bounds.height
        }
//        let turn1 = SKAction.rotate(byAngle: 2, duration: 1)
//        let turn2 = SKAction.rotate(byAngle: -2, duration: 1)
//        let turning = SKAction.sequence([turn1,turn2])
//        let repetition = SKAction.repeatForever(turning)
//        
//        let going = SKAction.move(to: CGPoint(x: CGFloat.random(in: 0...frame.size.width), y: -10), duration: 8)
//        let ending = SKAction.removeFromParent()
//        let repetition2 = SKAction.sequence([going,ending])
//        let traverse = SKAction.group([repetition,repetition2])
//        self.run(traverse)
    }
    
}
