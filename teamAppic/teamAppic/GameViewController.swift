//
//  GameViewController.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController, GameOVerProtocol{
    
    /// scene where the game actions are implemented
    var gameScene : GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
				
                self.gameScene = scene as! GameScene
                
                self.gameScene.hudController.timer.gameDelegate = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        // when the scene will disappear, setups the game over configuration
        self.gameScene.gameOverSetups()
    }
    
    public func gameOver() {
        self.performSegue(withIdentifier: "gameOverSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
