//
//  GameViewController.swift
//  Space Game
//
//  Created by Joshua Choe on 5/28/19.
//  Copyright © 2019 Joshua Choe. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var player : AVAudioPlayer?
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    private func initializePlayer() -> AVAudioPlayer? {
           guard let path = Bundle.main.path(forResource: "backingaudio", ofType: "wav") else {
               return nil
           }

           return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
       }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        player = initializePlayer()
        player?.numberOfLoops = -1
        player?.play()
    
        if let view = self.view as! SKView? {
            //view.showsPhysics = true
            // Load the SKScene from 'GameScene.sks'
            
            let scene = MainMenuScene(size: CGSize(width: 1125, height: 2436))
            
            // Set the scale mode to scale to fit the window
            
            scene.scaleMode = .aspectFill
            // Present the scene
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            
            
            view.showsNodeCount = false
        }
        
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
