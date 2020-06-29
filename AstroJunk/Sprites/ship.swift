//
//  ship.swift
//  AstroJunk
//
//  Created by Mondale on 6/9/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class Ship: SKSpriteNode{
    
    init() {
        let texture = SKTexture(imageNamed: "playerShip")
        let color = UIColor.clear
        let size = CGSize(width: 60, height: 44)
        super.init(texture: texture, color: color, size: size)
        self.name = "ship"
        self.zPosition = 4
        
        let fireEmitter = SKEmitterNode(fileNamed: "boosterFire.sks")!
        fireEmitter.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
//        fireEmitter.particleColor = .blue
        fireEmitter.zPosition = -1
        self.addChild(fireEmitter)
        
        //Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ship
//        self.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Junk
//        meteor.physicsBody!.contactTestBitMask = PhysicsCategory.Ship

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
