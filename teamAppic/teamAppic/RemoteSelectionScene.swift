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
    
    /// delegate to game view controller to have access to loading and presention of all scenes
    public weak var delegateGameVC : GameVCProtocol?
    
    /// delegate to game scene to select the type of control
    public weak var delegateGameScene : GameSceneProtocol?
    
    /// instance of buttons manager to use some nodes as buttons
    private var buttonsManager = ButtonsManager()
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupGestures()
    }
    
    /// Setups all gestures.
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
        
        let menuGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuTapped(_:)))
        let menuType = UIPressType.menu
        menuGestureRecognizer.allowedPressTypes = [NSNumber(value: menuType.rawValue)];
        self.view?.addGestureRecognizer(menuGestureRecognizer)
    }
    
    /// Function called when the menu is tapped in siri remote. When it is called, the menu scene is loaded and presented.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func menuTapped(_ sender: UITapGestureRecognizer) {
        self.delegateGameVC?.loadMenuScene()
    }
    
    /// Setups all nodes.
    func setupNodes() {
        // loading singlePlayer "button"
        let buttonsArray = [self.childNode(withName: "swipe") as! SKSpriteNode,
                            self.childNode(withName: "motion") as! SKSpriteNode]
        
        buttonsManager.insertButton(nodeArray: buttonsArray)
    }
    
    /// Function called when the select is tapped in siri remote and swipe or motion control is selected, depending on what button was selected.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func selectTapped(_ sender: UITapGestureRecognizer) {
        var typeOfControl : String!
        
        switch self.buttonsManager.pointerButton {
        // swipe button tapped
        case 0:
            typeOfControl = "swipe"
            break
        
        // motion button tapped
        case 1:
            typeOfControl = "motion"
            break
        
        default:
            break
        }
        
        // the game scene will be presented and the remote selection will be selected
        self.delegateGameVC?.presentGameScene()
        self.delegateGameScene?.selectRemoteType(typeOfControl: typeOfControl!)
    }
    
    /// Function called when the swipe left is done and the swipe left effect will be obtained in the buttons.
    ///
    /// - Parameter sender: UISwipeGestureRecognizer
    func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeUp()
    }
    
    /// Function called when the swipe right is done and the swipe right effect will be obtained in the buttons.
    ///
    /// - Parameter sender: UISwipeGestureRecognizer
    func swipeRight(_ sender: UISwipeGestureRecognizer) {
        buttonsManager.swipeDown()
    }
}
