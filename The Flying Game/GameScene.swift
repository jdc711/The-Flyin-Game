//
//  GameScene.swift
//  Space Game
//
//  Created by Joshua Choe on 5/28/19.
//  Copyright © 2019 Joshua Choe. All rights reserved.
//

import SpriteKit
import GameplayKit
var gameScore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    //the code contained inside didMoveToView immediately executes when this scene loads up
    var shootBool : Bool = true
    var player = SKSpriteNode()
    let bulletSound =
        SKAction.playSoundFileNamed("laserSound.wav", waitForCompletion: false)
    let explosionSound =
        SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    let gameArea  : CGRect
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    var levelNumber = 0
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    let beginLabel = SKLabelNode(fontNamed: "The Bold Font")
    var movingLeft: Bool = false
    func random() ->CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat ) -> CGFloat{
        return random() * (max - min) + min
    }
    
    struct physicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Enemy : UInt32 = 0b100
    }
    
    
    
    override init(size: CGSize) {
        
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect (x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        for i in 0...1 {
                let background = SKSpriteNode(imageNamed: "ocean")
                background.name = "Background"
                background.size = self.size
                background.anchorPoint = CGPoint(x: 0.5, y: 0)
                background.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
                background.zPosition = 0
            //background.setScale(CGFloat(signOf: self.size.width / 4, magnitudeOf: 0.8 ))
                self.addChild(background)
        }
           
        
        
        beginLabel.text = "Tap to Begin"
        beginLabel.fontSize = 100
        beginLabel.fontColor =  SKColor.white
        beginLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        beginLabel.zPosition = 100
        beginLabel.alpha = 0
        self.addChild(beginLabel)
        
        player = SKSpriteNode(imageNamed: "submarine")
        player.setScale(3.75)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height )
        player.zPosition = 2
        //player.zRotation = -3.14159 / 4
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width - 200)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        player.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height + scoreLabel.frame.size.height )
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.805, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.86, duration: 0.3)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        livesLabel.run(moveOnToScreenAction)
        scoreLabel.run(moveOnToScreenAction)
        beginLabel.run(fadeInAction)
        gameScore = 0
    }
    
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var amountToMovePerSec: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval){
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMoveBackground = amountToMovePerSec * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                background.position.y += self.size.height * 2
            }
        }
    }
    
    func beginGame(){
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let deleteAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOutAction, deleteAction])
        beginLabel.run(sequence)
        
        let playerInitialMove = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height * 0.2), duration: 0.3)
        let startLevelAction = SKAction.run {
          //  self.startLevel()
        }
        let startLevelSequence = SKAction.sequence([playerInitialMove, startLevelAction])
        player.run(startLevelSequence)
        
        
        
        
        startLevel()
    }
    
    
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        if gameScore == 15 {
            startLevel()
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "sand1"))
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                let seq = SKAction.sequence([fadeOut, changeTexture, fadeIn])
                background.run(seq)
            }
            player.texture = SKTexture(imageNamed: "magicCarpet")

            
        }
        else if gameScore == 30 {
            startLevel()
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "city1"))
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                let seq = SKAction.sequence([fadeOut, changeTexture, fadeIn])
                background.run(seq)
            }
            player.texture = SKTexture(imageNamed: "helicopter")

        }
        else if gameScore == 50 {
            startLevel()
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "sky1"))
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                let seq = SKAction.sequence([fadeOut, changeTexture, fadeIn])
                background.run(seq)
            }
            player.texture = SKTexture(imageNamed: "airplane")

        }
        else if gameScore == 70 {
            startLevel()
            player.texture = SKTexture(imageNamed: "secRocket")

        }
        
        else if gameScore == 100 {
            startLevel()
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "spaceBackground"))
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                let seq = SKAction.sequence([fadeOut, changeTexture, fadeIn])
                background.run(seq)
            }
            
            player.texture = SKTexture(imageNamed: "spaceShip")

        }
    }
    
    
    func fireBullet(){
        var bullet = SKSpriteNode(imageNamed: "bubbleBall")
        if (levelNumber == 2){
            bullet.texture = SKTexture(imageNamed: "rock")
        }
        else if (levelNumber == 3){
            bullet.texture = SKTexture(imageNamed: "book")
        }
        
        else if (levelNumber == 4){
            bullet.texture = SKTexture(imageNamed: "wind1")
        }
        else if (levelNumber == 5){
            bullet.texture = SKTexture(imageNamed: "bullet")
            bullet = SKSpriteNode(imageNamed: "bullet")
        }
        bullet.setScale(0.75)
        bullet.position = player.position
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        bullet.zPosition = 1
        self.addChild(bullet)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    enum gameState{
        case beforeGame
        case inGame
        case gameOver
    }
    
    var currentGameState = gameState.beforeGame
    
    
    func startLevel(){
        levelNumber += 1
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        var levelDuration = TimeInterval()
        
        switch levelNumber{
        case 1: levelDuration = 2
        case 2: levelDuration = 1.5
        case 3: levelDuration = 1.2
        case 4: levelDuration = 0.8
        case 5: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: levelDuration), SKAction.run(spawnEnemy)])), withKey: "spawningEnemies")
        
    }
    
    func runGameOver(){
        currentGameState = gameState.gameOver
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Enemy"){
            (enemy,stop) in
            enemy.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Bullet"){
            (bullet, stop) in
            bullet.removeAllActions()
        }
        let changeSceneAction = SKAction.run {
            self.changeScene()
        }
        let gameOverSeq = SKAction.sequence([SKAction.wait(forDuration: 1), changeSceneAction])
        self.run(gameOverSeq)
        
    }
    
    
    func spawnEnemy(){
        let randXStart = random(min: gameArea.minX + 50 , max: gameArea.maxX - 50)
        let randXEnd = random(min: gameArea.minX + 50, max: gameArea.maxX - 50)
        
        let startPt = CGPoint(x: randXStart, y: self.size.height * 1.2)
        let endPt = CGPoint (x: randXEnd, y: self.size.height * -0.2)
        
        let dx = startPt.x - endPt.x
        let dy = startPt.y - endPt.y
        
        var amountRotated = 3.14159/2 + atan2(dy, dx)
        
        var enemy = SKSpriteNode()
        //enemy.setScale(4)
        
        print(levelNumber)
        if (levelNumber == 1){
            enemy = SKSpriteNode(imageNamed: "shark")
            amountRotated -= 3.14159 / 2
            enemy.setScale(2)
        }
        else if (levelNumber == 2){
            enemy = SKSpriteNode(imageNamed: "metior")
            amountRotated -= 3.14159 / 2
            enemy.setScale(1.8)

        }
        else if (levelNumber == 3){
            enemy = SKSpriteNode(imageNamed: "flyingMan1")
            amountRotated -= 3.14159 / 2
            enemy.setScale(0.6)

        }
        else if (levelNumber == 4){
            enemy = SKSpriteNode(imageNamed: "bird")
            enemy.setScale(4)
            
        }
        
        else if (levelNumber == 5){
            enemy = SKSpriteNode(imageNamed: "android")
            enemy.setScale(4)
            
        }
        enemy.name = "Enemy"
       // enemy.setScale(4)
        enemy.position = startPt
        enemy.zPosition = 2
        enemy.zRotation = amountRotated
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Player | physicsCategories.Bullet
        self.addChild(enemy)
        
        
        let enemyMove = SKAction.move(to: endPt, duration: 3.2)
        let enemyDelete = SKAction.removeFromParent()
        let loseLife1 = SKAction.run {
            self.loseLife()
        }
        
        let enemySeq = SKAction.sequence([enemyMove, enemyDelete, loseLife1 ])
        if (currentGameState == gameState.inGame){
            enemy.run(enemySeq)
        }
        
    }
    
    func changeScene(){
        let newScene = GameOverScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(newScene, transition: transition)
    }
    
    
    func loseLife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        //let scaleUp = SKAction.scale(by: 1.5, duration: 0.2)//
       // let scaleDown = SKAction.scale(by: -1.5, duration: 0.2)
       // //let scaleSeq = SKAction.sequence([scaleUp, scaleDown])
        //livesLabel.run(scaleSeq)
        if (livesNumber == 0){
            runGameOver()
        }
    }
    
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if (body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy){
            
            if (body1.node != nil){
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if (body2.node != nil){
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        if (body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy ){
            if (body2.node?.position.y)! < self.size.height{
            addScore()
            
            if (body2.node != nil){
                spawnExplosion(spawnPosition: body2.node!.position)
                
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            }
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 4, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSeq  = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSeq)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (currentGameState == gameState.beforeGame){
            beginGame()
        }
        else if (currentGameState == gameState.inGame && shootBool){
            fireBullet()
            shootBool = false
            self.delay(0.6){
                self.shootBool = true
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let prevPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - prevPointOfTouch.x
            
          /*  if (amountDragged < 0 && movingLeft == false){
                
                movingLeft = true

player.texture = SKTexture(imageNamed: "flyingMan1")
                player.zRotation = -3.14159 / 4

            }*/
            /*else if (amountDragged > 0 && movingLeft){
                player.texture = SKTexture(imageNamed: "flipflyingMan1")

                player.zRotation = 3.14159 / 4
                movingLeft = false
            }*/
            
            if (currentGameState == gameState.inGame){
                player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
}



