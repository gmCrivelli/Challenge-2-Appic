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

class GameViewController: UIViewController, GameVCProtocol{
    
    /// scene where the game actions are implemented
    var gameScene : GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loads the menu scene, that is, the first scene when the app is opened
        loadMenuScene()
    }
    
    /// loads and presents the menu scene
    public func loadMenuScene() {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                let menuScene = scene as! MenuScene
                menuScene.delegateGameVC = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    /// loads and presents the game over scene
    public func loadGameOverScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameOverScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                let gameOverScene = scene as! GameOverScene
                gameOverScene.delegateGameVC = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    /// loads the game scene
    public func loadGameScene() {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                self.gameScene = scene as! GameScene
                
                self.gameScene.hudController.timer.gameDelegate = self
                self.gameScene.delegateGameVC = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    /// presents the game scene
    public func presentGameScene() {
        if let view = self.view as! SKView? {
            // Present the scene
            view.presentScene(self.gameScene)
        }
    }
    
    /// loads and presents  the remote control selection scene
    public func loadRemoteScene() {
        loadGameScene()
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "RemoteSelectionScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                let remoteScene = scene as! RemoteSelectionScene
                remoteScene.delegateGameVC = self
                remoteScene.delegateGameScene = self.gameScene
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    /// segue to performSegue to about view controller
    public func goToAbout() {
        performSegue(withIdentifier: "aboutSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
