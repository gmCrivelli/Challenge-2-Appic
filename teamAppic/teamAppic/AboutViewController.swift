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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "AboutScene") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill
				
				// Present the scene
				view.presentScene(scene)
				
			}
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
			
			// observer to know when pause is selected
			
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
}
