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
    
    private var highScore = SKLabelNode()
    
    private var buttonsArray = [SKSpriteNode]()
    
    public weak var delegateGameVC : GameVCProtocol?
    
    private var buttonsManager = ButtonsManager()
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup() {
        let setupNodes = SKAction.run {
            self.setupNodes()
        }
        let setupGestures = SKAction.run {
            self.setupGestures()
        }
        let showLabels = SKAction.run {
            for button in self.buttonsArray {
                button.run(SKAction.fadeIn(withDuration: self.DELAYTOFADE))
            }
        }
        let delay = SKAction.wait(forDuration: DELAYTOLOAD)
        self.run(SKAction.sequence([setupNodes, delay, showLabels, setupGestures]))
    }
    
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
    
    func setupNodes() {
        // inserting the high score in the text of the high score label
        self.highScore = self.childNode(withName: "highScoreValue") as! SKLabelNode
        self.highScore.text = String(Score.getHighScore())
        
        // loading singlePlayer "button"
        self.buttonsArray = [self.childNode(withName: "restart") as! SKSpriteNode,
                            self.childNode(withName: "menu") as! SKSpriteNode]
        
        buttonsManager.insertButton(nodeArray: buttonsArray)
    }
    
    func selectTapped(_ sender: UITapGestureRecognizer) {
        switch self.buttonsManager.pointerButton {
        case 0:
            self.delegateGameVC?.loadGameScene()
            self.delegateGameVC?.presentGameScene()
        case 1:
            self.delegateGameVC?.loadMenuScene()
        default:
            break
        }
    }
    
    func swipeUp(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeUp()
    }
    
    func swipeDown(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeDown()
    }
}
