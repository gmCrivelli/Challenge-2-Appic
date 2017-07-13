//
//  AboutViewController.swift
//  MenuTest
//
//  Created by Scarpz on 04/07/17.
//  Copyright © 2017 Scarpz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class AboutViewController: UIViewController {
	
	override func viewDidLoad(){
		super.viewDidLoad()
        
        loadAboutScene()
	}
    
    /// loads and presents the about scene
    private func loadAboutScene() {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "AboutScene") {
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
