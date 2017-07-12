//
//  RemoteSelectionScene.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 11/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import QuartzCore

/// protocol to access game scene, in order to selects the type of control that will be used in the game
protocol GameSceneProtocol : NSObjectProtocol {
    func selectRemoteType(typeOfControl : String)
}

class RemoteSelectionScene : SKScene {
    
    public weak var delegateGameVC : GameVCProtocol?
    
    public weak var delegateGameScene : GameSceneProtocol?
    
    private var buttonsManager = ButtonsManager()
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupGestures()
    }
    
    func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
        swipeRight.direction = .right
        self.view?.addGestureRecognizer(swipeRight)
        
        let selectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
        let pressType = UIPressType.select
        selectGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
        self.view?.addGestureRecognizer(selectGestureRecognizer)
    }
    
    func setupNodes() {
        // loading singlePlayer "button"
        let buttonsArray = [self.childNode(withName: "swipe") as! SKSpriteNode,
                            self.childNode(withName: "motion") as! SKSpriteNode]
        
        buttonsManager.insertButton(nodeArray: buttonsArray)
    }
    
    func selectTapped(_ sender: UITapGestureRecognizer) {
        var typeOfControl : String!
        switch self.buttonsManager.pointerButton {
        case 0:
            // swipe control
            typeOfControl = "swipe"
            break
        case 1:
            // motion control
            typeOfControl = "motion"
            break
        default:
            break
        }
        self.delegateGameVC?.presentGameScene()
        self.delegateGameScene?.selectRemoteType(typeOfControl: typeOfControl!)
    }
    
    func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeUp()
    }
    
    func swipeRight(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeDown()
    }
}
