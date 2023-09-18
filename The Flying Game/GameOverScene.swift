//
//  GameOverScene.swift
//  Space Game
//
//  Created by Joshua Choe on 5/29/19.
//  Copyright © 2019 Joshua Choe. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel =  SKLabelNode(fontNamed: "The Bold Font")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "ocean1")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 170
        gameOverLabel.color = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.color = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highscoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if (gameScore > highscoreNumber){
            highscoreNumber = gameScore
            defaults.set(highscoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highscoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.color = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        
       
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.color = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if (restartLabel.contains(pointOfTouch)){
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(newScene, transition: transition)
            }
        }
    }
    
    
}
