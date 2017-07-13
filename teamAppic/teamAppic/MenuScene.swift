//
//  MenuScene.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 11/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import QuartzCore

/// protocol to load all scenes using the game view controller
protocol GameVCProtocol : NSObjectProtocol {
    /// presents the game scene
    func presentGameScene()
    /// loads the game scene
    func loadGameScene()
    /// loads and presents the game over scene
    func loadGameOverScene()
    /// loads and presents  the menu scene
    func loadMenuScene()
    /// loads and presents  the remote control selection scene
    func loadRemoteScene()
    /// segue to performSegue to about view controller
    func goToAbout()
}

class MenuScene : SKScene {
    
    /// label to show the highscore
    private var highScore = SKLabelNode()
    
    /// delegate to have access to the loading of other scenes
    public weak var delegateGameVC : GameVCProtocol?
    
    /// instance of buttons manager to use some nodes as buttons
    private var buttonsManager = ButtonsManager()
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupGestures()
    }
    
    /// Setups all gestures.
    func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
        
        let selectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
        let pressType = UIPressType.select
        selectGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
        self.view?.addGestureRecognizer(selectGestureRecognizer)
    }
    
    /// Setups all nodes of scene.
    func setupNodes() {
        // inserting the high score in the text of the high score label
        self.highScore = self.childNode(withName: "highScoreValue") as! SKLabelNode
        self.highScore.text = String(Score.getHighScore())
        
        // loading singlePlayer "button"
        let buttonsArray = [self.childNode(withName: "SinglePlayer") as! SKSpriteNode,
                            self.childNode(withName: "MultiPlayer") as! SKSpriteNode,
                            self.childNode(withName: "About") as! SKSpriteNode
                            ]
        buttonsManager.insertButton(nodeArray: buttonsArray)
    }
    
    /// functin called when the select button from siri remote is tapped
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func selectTapped(_ sender: UITapGestureRecognizer) {
        
        switch self.buttonsManager.pointerButton {
        // singleplayer button tapped
        case 0:
            self.delegateGameVC?.loadRemoteScene()
        
        // multiplayer button tapped
        case 1:
            // multiplayer
            break
        
        // about button tapped
        case 2:
            self.delegateGameVC?.goToAbout()
        
        default:
            break
        }
    }
    
    /// Function called when the swipe up is done and the swipe up effect will be obtained in the buttons.
    ///
    /// - Parameter sender: UISwipeGestureRecognizer
    func swipeUp(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeUp()
    }
    
    /// Function called when the swipe down is done and the swipe down effect will be obtained in the buttons.
    ///
    /// - Parameter sender: UISwipeGestureRecognizer
    func swipeDown(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeDown()
    }
}
