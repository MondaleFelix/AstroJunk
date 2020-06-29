//
//  Meteor.swift
//  AstroJunk
//
//  Created by Mondale on 6/9/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
enum MeteorType: String, CaseIterable{
    case greyBig = "meteorGrey_big"
    case greyMed = "meteorGrey_med"
    case brownBig = "meteorBrown_big"
}
class Meteor: SKSpriteNode{
    
    init(){
        let randomTexture = MeteorType.allCases.randomElement()!
        let texture = SKTexture(imageNamed: randomTexture.rawValue)
        let color = UIColor.clear
        let size = CGSize(width: 30, height: 30)
        super.init(texture: texture, color: color, size: size)
        self.name = "meteor"
        self.zPosition = 2
        
        //Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveMeteor(scene: SKScene){
        if let view = scene.view{
            position.x = CGFloat.random(in: 0...view.bounds.width)
            position.y = view.bounds.height
        }
        
//        let turn = SKAction.rotate(byAngle: 20, duration: 1)
//        let spin = SKAction.repeatForever(turn)
//        
//        let moveDown = SKAction.move(to: CGPoint(x: CGFloat.random(in: 0...scene.frame.size.width), y: -10), duration: 4)
//        
//        let remove = SKAction.removeFromParent()
//        let fall = SKAction.sequence([moveDown,remove])
//        let falling = SKAction.group([spin, fall])
//    
//        self.run(falling)
    }
}
