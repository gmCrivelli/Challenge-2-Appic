//
//  GameOverController.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 09/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverLabel.textColor = .blue
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
