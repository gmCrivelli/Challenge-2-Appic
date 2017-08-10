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
    /// shows the leaderboards
    func showLeader()
    /// adds score to the leaderboards
    func addScoreAndSubmitToGC()
}

class MenuScene : SKScene {
    
    /// label to show the highscore
    private var highScore = SKLabelNode()
    
    /// node to show the button sound button
    private var soundButton = SKSpriteNode()
    
    /// node to show the sound icon button
    private var soundIcon = SKSpriteNode()
    
    /// node to show the no sound icon button
    private var noSoundIcon = SKSpriteNode()
    
    /// delegate to have access to the loading of other scenes
    public weak var delegateGameVC : GameVCProtocol?
    
    /// instance of buttons manager to use some nodes as buttons
    private var buttonsManager = ButtonsManager()
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupGestures()
        setupMusics()
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
        
        // loading the sound button
        self.soundButton = self.childNode(withName: "soundButton") as! SKSpriteNode
        soundIconAppears()
        
        // loading singlePlayer "button"
        let buttonsArray = [self.childNode(withName: "SinglePlayer") as! SKSpriteNode,
                            self.childNode(withName: "MultiPlayer") as! SKSpriteNode,
                            self.childNode(withName: "About") as! SKSpriteNode,
                            self.soundButton,
                            ]
        buttonsManager.insertButton(nodeArray: buttonsArray)
    }
    
    /// Setups menu music when the app is loaded
    func setupMusics() {
        MusicManager.instance.playMenuAudio()
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
        
        // sound button tapped
        case 3:
            self.gameAudioPressed()
        default:
            break
        }
    }
    
    /// function to represents the gameAudio button pressed
    func gameAudioPressed() {
        // mute and dismute the volume of musics
        MusicManager.instance.pressGameAudio()
        soundIconAppears()
    }
    
    /// Function that decides what button music volume will appear according to musicManeger.volumeSound boolean.
    func soundIconAppears() {
        let musicManager = MusicManager.instance
        if (musicManager.volumeSound) {
            self.soundButton.texture = SKTexture(imageNamed: "soundIcon")
        } else {
            self.soundButton.texture = SKTexture(imageNamed: "noSoundIcon")
        }
        self.soundButton.alpha = 1
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
