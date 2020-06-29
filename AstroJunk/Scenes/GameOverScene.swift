//
//  GameOverScene.swift
//  AstroJunk
//
//  Created by Mondale on 6/11/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let overLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    var endScore = 0
    
    let screen = SKAction.playSoundFileNamed("scifiUI1.mp3", waitForCompletion: true)
    
    override init(size: CGSize) {
        // do initial configuration work here
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didMove(to view: SKView) {
        let space = SKSpriteNode(imageNamed: "space_background")
        space.size = UIScreen.main.bounds.size
        space.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(space)
        createButton()
        createLabels()
    }
    
    func createLabels(){
        overLabel.text = "Poor Ben"
        overLabel.fontColor = .green
        overLabel.fontName = "Helvetica Bold"
        overLabel.zPosition = 5
        overLabel.position = CGPoint(x: frame.size.width/2, y: self.frame.midY + 100)
        overLabel.horizontalAlignmentMode = .center
        overLabel.verticalAlignmentMode = .center
        self.addChild(overLabel)
        
        scoreLabel.text = "Ben got \(endScore) chickens!"
        scoreLabel.fontColor = .green
        scoreLabel.fontName = "Helvetica Bold"
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: frame.size.width/2, y: self.frame.midY - 85)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        self.addChild(scoreLabel)
    }
    
    func createButton(){
        //Button
        let buttonTexture = SKTexture(imageNamed: "button")
        let buttonSelected = SKTexture(imageNamed: "button2")
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameOverScene.buttonTap))
        button.setButtonLabel(title: "Play Again", font: "Helvetica", fontSize: 20)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.zPosition = 20
        button.name = "button"
        self.addChild(button)
    }
    
    @objc func buttonTap(){
        let gameScene = GameScene(size: (self.view?.bounds.size)!)
        self.run(screen)
        
        gameScene.scaleMode = .aspectFill
        let crossFade = SKTransition.crossFade(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(gameScene, transition: crossFade)
        }
    }
}
