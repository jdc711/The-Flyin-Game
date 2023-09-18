//
//  MainMenu.swift
//  Space Game
//
//  Created by Joshua Choe on 5/30/19.
//  Copyright © 2019 Joshua Choe. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    override func didMove(to view: SKView) {
       
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = 0
        self.addChild(background)
        
        let joshNameLabel = SKLabelNode(fontNamed: "The Bold Font")
        joshNameLabel.text = "Delta Tech's"
        joshNameLabel.fontColor = SKColor.white
        joshNameLabel.zPosition = 100
        joshNameLabel.fontSize = 75
        joshNameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.8)
        self.addChild(joshNameLabel)

        
        let spaceGameLabel1 = SKLabelNode(fontNamed: "The Bold Font")
        spaceGameLabel1.text = "The Flyin"
        spaceGameLabel1.fontColor = SKColor.white
        spaceGameLabel1.zPosition = 100
        spaceGameLabel1.fontSize = 210
        spaceGameLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        self.addChild(spaceGameLabel1)

        
        
        let spaceGameLabel2 = SKLabelNode(fontNamed: "The Bold Font")
        spaceGameLabel2.text = "Game"
        spaceGameLabel2.fontColor = SKColor.white
       spaceGameLabel2.zPosition = 100
        spaceGameLabel2.fontSize = 210
        spaceGameLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        self.addChild(spaceGameLabel2)

        
        let startLabel = SKLabelNode(fontNamed: "The Bold Font")
        startLabel.text = "Start Game"
        startLabel.name = "startButton"
        startLabel.zPosition = 100
        startLabel.fontColor = SKColor.white
        startLabel.fontSize = 120
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        self.addChild(startLabel)
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = atPoint(pointOfTouch)
            
            if nodeTapped.name == "startButton"{
                let sceneToMoveto = GameScene(size: self.size)
               sceneToMoveto.scaleMode = self.scaleMode
            let moveAction = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveto, transition: moveAction)
            }
        }
    }
    
}
