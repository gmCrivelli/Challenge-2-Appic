//
//  GameOverScene.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 11/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import QuartzCore

class GameOverScene : SKScene {
    
    /// delay to restart
    let DELAYTOLOAD : TimeInterval = 1
    /// delay to fade
    let DELAYTOFADE : TimeInterval = 0.2
    
    /// highscore label to show the high score in game
    private var highScore = SKLabelNode()
    
    /// current score label of the player
    private var currentScore = SKLabelNode()
    
    /// Plank of first player.
    private var plank1 = SKSpriteNode()
    
    /// array that contains all buttons used with the ButtonsManager class
    private var buttonsArray = [SKSpriteNode]()
    
    /// delegate to game view controller to have access to loading and presention of all scenes
    public weak var delegateGameVC : GameVCProtocol?
    
    /// instance of buttons manager to use some nodes as buttons
    private var buttonsManager = ButtonsManager()
    
    /// hud controller to get access to its elements
    let hudController = HudController.hudInstance
    
    override func didMove(to view: SKView) {
        // setups gestures and nodes
        setup()
        
        // setups musics of this scene
        setupGameOverMusics()
    }
    
    /// Setups nodes and gestures. In this function there is a delay implemented in order to not allow player restart the game cause he was shooting in game scene before the game over ends.
    func setup() {
        let setupNodes = SKAction.run {
            self.setupNodes()
        }
        let setupGestures = SKAction.run {
            self.setupGestures()
        }
        // action to show the buttons
        let showButtons = SKAction.run {
            for button in self.buttonsArray {
                button.run(SKAction.fadeIn(withDuration: self.DELAYTOFADE))
            }
        }
        let delay = SKAction.wait(forDuration: DELAYTOLOAD)
        self.run(SKAction.sequence([setupNodes, delay, showButtons, setupGestures]))
    }
    
    /// Setups the Game Over music when the Game Over scene is called.
    func setupGameOverMusics() {
        
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
        
        let menuGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuTapped(_:)))
        let menuType = UIPressType.menu
        menuGestureRecognizer.allowedPressTypes = [NSNumber(value: menuType.rawValue)];
        self.view?.addGestureRecognizer(menuGestureRecognizer)
    }
    
    /// function called when menu is tapped.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func menuTapped(_ sender: UITapGestureRecognizer) {
        removeAllGestures()
        self.delegateGameVC?.loadMenuScene()
    }
    
    func setupNodes() {
        // inserting the high score in the text of the high score label
        self.highScore = self.childNode(withName: "highScoreValue") as! SKLabelNode
        self.highScore.text = String(Score.getHighScore())
        
        // inserts the buttons in buttonsManager array
        self.buttonsArray = [self.childNode(withName: "restart") as! SKSpriteNode,
                            self.childNode(withName: "leaderboards") as! SKSpriteNode]
        buttonsManager.insertButton(nodeArray: buttonsArray)
        
        // inserts the current score in its label text
        plank1 = self.childNode(withName: "plank1") as! SKSpriteNode
        currentScore = plank1.childNode(withName: "currentScore") as! SKLabelNode
        currentScore.text = String(hudController.playerArray[0].score.currentScore)
        
        // reinitializes current score of all players
        hudController.gameOverHighScore()
    }
    
    /// Function called when the select is tapped in siri remote and swipe or motion control is selected, depending on what button was selected.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func selectTapped(_ sender: UITapGestureRecognizer) {
        
        switch self.buttonsManager.pointerButton {
        // restart button tapped
        case 0:
            // removes all gestures before transition of this scene
            removeAllGestures()
            
            self.delegateGameVC?.loadRemoteScene()
        // leaderboards button tapped
        case 1:
            self.delegateGameVC?.showLeader()
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
    
    /// removes all gestures from this view
    private func removeAllGestures() {
        if let view = self.view as UIView! {
            view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
        }
    }
}
