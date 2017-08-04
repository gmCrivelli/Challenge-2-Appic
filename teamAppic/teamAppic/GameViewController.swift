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
import GameKit

class GameViewController: UIViewController, GameVCProtocol, GKGameCenterControllerDelegate{
    
    /// scene where the game actions are implemented
    var gameScene : GameScene!
    
    /// leaderboard id used in itunes connect
    let LEADERBOARD_ID = "circuSplash.highScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // authenticating game center leaderboards
        authenticateLocalPlayer()
        
        //loads all musics of game
        MusicManager.instance.setupMusics()
        
        // loads the menu scene, that is, the first scene when the app is opened
        loadMenuScene()
    }
    
    /// loads and presents the menu scene
    public func loadMenuScene() {
        // sures that all gestures will be removed
        removeAllGestures()
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
                
                // sets delegates from gameScene
                self.gameScene.hudController.timer.gameDelegate = self
                self.gameScene.hudController.timer.gameSceneDelegate = self.gameScene
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
    
    /// removes all gestures from this view
    private func removeAllGestures() {
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
    }
    
    
    /// authenticates local player
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
            }
        }
    }
    
    /// submits the final score to game center
    func addScoreAndSubmitToGC() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let score = Score.getHighScore()
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(score)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    
    /// Function called after gameCenterViewController is finished.
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    /// Shows leaderboard screen.
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
}
