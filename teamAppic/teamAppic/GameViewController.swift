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

class GameViewController: UIViewController, GameOVerProtocol, GameVCProtocol{
    
    /// scene where the game actions are implemented
    var gameScene : GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMenuScene()
    }
    
    public func loadMenuScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                let menuScene = scene as! MenuScene
                menuScene.delegateGameVC = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    public func loadGameOverScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameOverScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    public func loadGameScene() {
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

//    override func viewWillDisappear(_ animated: Bool) {
//        // when the scene will disappear, setups the game over configuration
//        self.gameScene.gameOverSetups()
//    }
    
//    public func gameOver() {
//        self.performSegue(withIdentifier: "gameOverSegue", sender: self)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destVC = segue.destination as? GameOverViewController {
//            destVC.delegateGameVC = self
//        }
//    }
    
    public func goToAbout() {
        performSegue(withIdentifier: "aboutSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
