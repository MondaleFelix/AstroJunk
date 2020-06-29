//
//  GameScene.swift
//  AstroJunk
//
//  Created by Mondale on 6/4/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var ship: Ship!
    let lifeLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    
    //MARK: Conditions
    var lives = 3
    var score = 0
//    var combo = 0
    
    //MARK: Sounds
    let crash = SKAction.playSoundFileNamed("hurt.mp3", waitForCompletion: false)
//    let explode = SKAction.playSoundFileNamed("boom.mp3", waitForCompletion: false)
    let captureSound = SKAction.playSoundFileNamed("yummy.mp3", waitForCompletion: false)
    
    public var SFXPlayer: AVAudioPlayer?
    
    //MARK: Game Loop
    override func didMove(to view: SKView) {
        //MARK: Background
        let space = SKSpriteNode(imageNamed: "space_background")
        space.size = UIScreen.main.bounds.size
        space.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(space)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)

        
        createShip()
        createMeteorAndDebris()
        createLabel()
    }
    
    override func update(_ currentTime: TimeInterval){
        lifeLabel.text = "Lives: \(lives)"
        lifeLabel.fontSize = 30
        lifeLabel.fontColor = .green
        scoreLabel.fontColor = .green
        scoreLabel.fontSize = 30
        scoreLabel.text = "Score: \(score)"
    }
    
    override func didEvaluateActions() {
//        checkCollisions()
//        checkJunkCollizsions()
        
        if lives == 0{
            self.playSoundEffect("boom.mp3")
            gameOver()
        }
    }
    
    
    //MARK: Create Label
    func createLabel(){
        lifeLabel.text = "Lives: \(lives)"
        lifeLabel.fontSize = 20
        lifeLabel.zPosition = 10
        lifeLabel.position = CGPoint(x: 20, y: frame.size.height - 20)
        lifeLabel.horizontalAlignmentMode = .left
        lifeLabel.verticalAlignmentMode = .top
        self.addChild(lifeLabel)
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 20
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: frame.size.width - 20, y: frame.size.height - 20)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        self.addChild(scoreLabel)
    }
    
    //MARK: Create Ship
    func createShip(){
        ship = Ship()
        ship.position = CGPoint(x: frame.size.width/2, y: frame.size.height/8)
        self.addChild(ship)
    }
    
    //MARK: Create Meteor
    func createMeteor(){
        //Meteor
        let meteor = Meteor()
        meteor.moveMeteor(scene: self)
        meteor.zPosition = 2
        self.addChild(meteor)

    }
    
    //MARK: Create Junk
    func createJunk(){
        let junk1 = Junk()
        junk1.moveJunk(scene: self)
        junk1.zPosition = 2
        self.addChild(junk1)
    }
    
    //MARK: Create Meteor and Debris
    func createMeteorAndDebris(){
        let wait = SKAction.wait(forDuration: 2)
        let createObject = SKAction.run{
            if Bool.random(){
                self.createJunk()
            }else{
                self.createMeteor()
            }
        }
        let objects = SKAction.sequence([wait,createObject])
        let fallingObjects = SKAction.repeatForever(objects)
        self.run(fallingObjects)
    }
    
    //MARK: Physics Collision
    
    func didBegin(_ contact: SKPhysicsContact) {
        //1
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //2
        if collision == PhysicsCategory.Ship | PhysicsCategory.Junk {
            print("Ben got junk")
            self.score += 1
            self.run(captureSound)
            
            if (contact.bodyA.node?.isKind(of: Junk.self))!{
                contact.bodyA.node?.removeFromParent()
            }else if (contact.bodyB.node?.isKind(of: Junk.self))!{
                contact.bodyB.node?.removeFromParent()
            }

        }else if collision == PhysicsCategory.Ship | PhysicsCategory.Meteor {
            print("Ben got hit with a rock")
            self.lives -= 1
            self.run(crash)
            
            if (contact.bodyA.node?.isKind(of: Meteor.self))!{
                let pso = contact.bodyA.node?.position
                let mplosion = SKEmitterNode(fileNamed: "mExplosion.sks")!
                mplosion.position = pso!
                mplosion.zPosition = 1
                self.addChild(mplosion)
                contact.bodyA.node?.removeFromParent()
            }else if (contact.bodyB.node?.isKind(of: Meteor.self))!{
                let pso = contact.bodyB.node?.position
                let mplosion = SKEmitterNode(fileNamed: "mExplosion.sks")!
                mplosion.position = pso!
                mplosion.zPosition = 1
                self.addChild(mplosion)
                contact.bodyB.node?.removeFromParent()
            }
            
        

        }
    }
    
    //MARK: Collisions
    func collision(with: SKSpriteNode){
        with.removeFromParent()
        print("Points: \(self.score)")
        print("Junk Collision")
    }
    
    func Mcollision(with: SKSpriteNode){
        self.run(crash)
        //        self.playSoundEffect("error.mp3")
        let pso = with.position
        with.removeFromParent()
        
        let mplosion = SKEmitterNode(fileNamed: "mExplosion.sks")!
        mplosion.position = pso
        mplosion.zPosition = 1
        self.addChild(mplosion)
        
        print("Meteor Collision")
    }
    
    func checkCollisions(){
        var hits: [SKSpriteNode] = []
        self.enumerateChildNodes(withName: "meteor"){ node, _ in
            let meteorNode = node as! SKSpriteNode
            if meteorNode.frame.intersects(self.ship.frame){
                hits.append(meteorNode)
            }
        }
        
        for node in hits{
            self.Mcollision(with: node)
            self.lives -= 1
        }
    }
    
    func checkJunkCollisions(){
        var hits: [SKSpriteNode] = []
        self.enumerateChildNodes(withName: "junk"){ node, _ in
            let junkNode = node as! SKSpriteNode
            if junkNode.frame.intersects(self.ship.frame){
                hits.append(junkNode)
            }
        }
        
        for node in hits{
            self.run(self.captureSound)
            //                    self.playSoundEffect("zap-whoosh.mp3")
            self.score += 1
            self.collision(with: node)
        }
    }
    
    //MARK: Touches Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: self)
        let shipPoistion = CGPoint(x: position.x, y: frame.size.height/8)
        let movement = SKAction.move(to: shipPoistion, duration: 0.4)
        ship.run(movement)
    }
    
    //MARK: Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //MARK: Sound Effects
    public func playSoundEffect(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil) // 3)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            SFXPlayer = try AVAudioPlayer(contentsOf: url!) // 4)
        } catch let error1 as NSError {
            error = error1
            SFXPlayer = nil
        }
        if let player = SFXPlayer {
            player.numberOfLoops = 0 // 5)
            player.prepareToPlay() // 6)
            player.play() // 7)
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
    
    //MARK: Transistions
    func gameOver(){
        let gameOverScene = GameOverScene(size: (self.view?.bounds.size)!)
        gameOverScene.scaleMode = .aspectFill
        gameOverScene.endScore = self.score
        let crossFade = SKTransition.crossFade(withDuration: 0.75)
        view?.presentScene(gameOverScene, transition: crossFade)
    }
    
//    func touchDown(atPoint pos : CGPoint) {
//
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//
//    }
//
//
    
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
}
