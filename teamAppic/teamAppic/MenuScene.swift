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

class MenuScene : SKScene {
    
    let increaseAction = SKAction.scale(by: 1.2, duration: 0.3)
    
    private var highScore = SKLabelNode()
    
    private var buttons = [SKSpriteNode]()
    
    private var buttonsBool = [Bool]()
    
    private var pointerButton : Int = 0
    
    public weak var delegateGameVC : GameVCProtocol?
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupGestures()
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
        self.buttons.append(self.childNode(withName: "SinglePlayer") as! SKSpriteNode)
        self.buttons.append(self.childNode(withName: "MultiPlayer") as! SKSpriteNode)
        self.buttons.append(self.childNode(withName: "About") as! SKSpriteNode)
        
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    private func increaseScale(node : SKSpriteNode) {
        node.run(increaseAction)
    }
    
    private func decreaseScale(node : SKSpriteNode) {
        node.run(increaseAction.reversed())
    }
    
    func swipeUp(_ sender: UISwipeGestureRecognizer) {
        decreaseScale(node: self.buttons[self.pointerButton])
        downPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    func swipeDown(_ sender: UISwipeGestureRecognizer) {
        decreaseScale(node: self.buttons[self.pointerButton])
        upPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    func selectTapped(_ sender: UITapGestureRecognizer) {
        switch self.pointerButton {
        case 0:
            self.delegateGameVC?.loadGameScene()
        case 1:
            break
        case 2:
            self.delegateGameVC?.loadMenuScene()
        default:
            break
        }
    }
    
    private func upPointer() {
        if (self.pointerButton < (self.buttons.count - 1)) {
            self.pointerButton += 1
        }
    }
    private func downPointer() {
        if (self.pointerButton > 0) {
            self.pointerButton -= 1
        }
    }
}
