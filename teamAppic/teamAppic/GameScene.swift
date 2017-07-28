//
//  GameScene.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import QuartzCore

// values used to possibilitate the movement along all the screen in motion
/// value used to x axe to possibilitate the movement along all the screen in horizontal
let PX = 0.7
/// value used to y axe to possibilitate the movement along all the screen in vertical
let PY = 0.35

class GameScene: SKScene, ReactToMotionEvents, GameSceneProtocol, UIGestureRecognizerDelegate {
    
    //Nodes and TargetController
    var gameNode = SKNode()
    var pauseNode = SKSpriteNode()
    var targetController : TargetController!
    
    // hud controller
    let hudController = HudController.hudInstance
    
    //Controller mode
    var controllerSwipeMode: Bool = false
    
    //Positions
    var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
    var currentTouchPosition: CGPoint! = CGPoint(x: 0.0, y: 0.0)
    
    //Motion update
    var lastX: Double! = 0
    var lastY : Double! = 0
    
    // this two array must have the same length
    var playerNameArray = [String]()
    var playerAimArray = [SKSpriteNode]()
    
    var lastUpdateTimeInterval : TimeInterval = 0
    var entityManager: EntityManager!
    
    private var panVel : CGPoint = CGPoint(x: 0.0, y: 0.0)
    private let dampening:CGFloat = 0.87
    
    /// delegate to game view controller to have access to loading and presention of all scenes
    public weak var delegateGameVC : GameVCProtocol?
    
    ///		Called after moving to the View,
    ///	call all setup Functions.
    ///
    /// - Parameters:
    ///   - view: SKView
    override func didMove(to view: SKView) {
        setupScenes()
        setupEntities()
        setupNodes()
        setupGestures()
        setupMusics()
    }
    
    /// Setups the circus music when the game is being played
    func setupMusics() {
        MusicManager.instance.playGameAudio()
    }
    
    /// Setups the game over configurations
    func gameOverSetups() {
        // removes all gestures
        removeAllGestures()
        
        // tops the game music
        MusicManager.instance.stopGameAudio()
        
        // initializes current score of all players
        hudController.gameOverHighScore()
        
        // sures that every node will be removed when the game overs or menu is selected
        self.gameNode.removeAllChildren()
        self.gameNode.removeFromParent()
        
        // invalidate the scheduled timer
        hudController.timer.pauseTimer()
    }
    
    /// Setups the Scenes.
    func setupScenes() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
    }
    
    func setupEntities() {
        entityManager = EntityManager(scene: self)
        entityManager.delegateGameScene = self
        
        let patternInstantiator = PatternInstantiator(entityManager: entityManager)
        
        var actionSequence = [SKAction]()
        
        for (t, pc) in patternInstantiator.patternArray {
            
            let waitAction = SKAction.wait(forDuration: t)
            
            let cannonAction = SKAction.run {
                self.run(SKAction.sequence(pc.sequence))
            }
            
            actionSequence.append(waitAction)
            actionSequence.append(cannonAction)
        }
        
        self.run(SKAction.sequence(actionSequence))
    }
    
    ///		Setup the Nodes.
    ///
    func setupNodes(){
        // getting the reference of gameNode and pauseNode from sks
        self.gameNode = self.childNode(withName: "gameNode")!
        self.pauseNode = self.childNode(withName: "pauseNode") as! SKSpriteNode
        
        // initializing player array and aim array (single player for now)
        playerNameArray = ["Player 1"]
        playerAimArray = [gameNode.childNode(withName: "aim1") as! SKSpriteNode]
        
        targetController = TargetController(screenSize: self.size, gameNode: gameNode, entityManager: entityManager)
        
        self.targetController.delegateHud = self.hudController
        
        // inserts players (single player)
        hudController.insertPlayers(playerNameArray: playerNameArray, playerAimArray: playerAimArray)
        hudController.setHUD(gameNode: gameNode)
        print("HIGHSCORE : \(Score.getHighScore())")

    }
    
    /// Setups the gestures.
    func setupGestures(){
        
        // setups the select (button of siri remote) gesture
        let selectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
        let pressType = UIPressType.select
        selectGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
        self.view?.addGestureRecognizer(selectGestureRecognizer)
        
        // setups the play/pause (button of siri remote) gesture
        let pauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pauseTapped(_:)))
        let pauseType = UIPressType.playPause
        pauseGestureRecognizer.allowedPressTypes = [NSNumber(value: pauseType.rawValue)];
        self.view?.addGestureRecognizer(pauseGestureRecognizer)
        
        // setups the menu (button of siri remote) gesture
        let menuGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuTapped(_:)))
        let menuType = UIPressType.menu
        menuGestureRecognizer.allowedPressTypes = [NSNumber(value: menuType.rawValue)];
        self.view?.addGestureRecognizer(menuGestureRecognizer)
        
        // setups the swipe motion
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panAim(_:)))
        panGestureRecognizer.delegate = self
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    /// Function that catches the gesture for menu in siri remote and loads the menu scene after setups all game over setups.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func menuTapped(_ sender: UITapGestureRecognizer) {
        // does everything needed after the game ends and loads the menu scene
        self.gameOverSetups()
        self.delegateGameVC?.loadMenuScene()
    }
    
    /// Function that catches the Gesture for tap in
    ///	in the controller, executes the target controller
    ///	detectHit function.
    ///
    /// - Parameters:
    ///   - sender: UITapGestureRecognizer
    func selectTapped(_ sender: UITapGestureRecognizer) {
        if (!self.gameNode.isPaused) {
            targetController.detectHit(playerAimArray[0].position, player: 0)
            print("Player 1 name: \(hudController.playerArray[0].playerName)")
            print("Current score Player 1: \(hudController.playerArray[0].score.currentScore)")
        }
    }
    
    //    func addNodesEntities() {
    //        print("ENTIDADES: \(entityManager.entities)")
    //        for ent in entityManager.entities {
    //            print(ent.component(ofType: SpriteComponent.self)?.node)
    //        }
    //    }
    
    /// Catches the gesture for pause in the tv control and pauses the game.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func pauseTapped(_ sender : UITapGestureRecognizer) {
        self.isPaused = !(self.isPaused)
        if self.isPaused == false {
            lastUpdateTimeInterval = 0
        }
        
        // reduces the alpha of all game, presents the pause menu and reduces the music volume if the game is paused
        if (self.isPaused) {
            self.hudController.timer.pauseTimer()
            self.pauseNode.alpha = 1
            self.gameNode.alpha = 0.3
            MusicManager.instance.lowGameAudio()
        } else {
            self.hudController.timer.resumeTimer()
            self.pauseNode.alpha = 0
            self.gameNode.alpha = 1
            MusicManager.instance.highGameAudio()
        }
    }
    
    /// Override of the function Update, called
    ///	every frame update, sets the aim new position
    ///	based on the controller mode.
    ///
    /// - Parameters:
    ///   - currentTime: TimeInterval
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        
        // Called before each frame is rendered
        playerAimArray[0].removeAllActions()
        
        if !controllerSwipeMode {
            
            playerAimArray[0].position = currentAimPosition
            
        } else {
            
            let maxX:CGFloat = self.size.width/2
            let maxY:CGFloat = self.size.height/2
            
            /*
            let p_x:CGFloat = self.size.width/2
            let p_y:CGFloat = self.size.height/2
            
            var posX = playerAimArray[0].position.x + currToPosX * movementPerSec * timeInterval
            var posY = playerAimArray[0].position.y + currToPosY * movementPerSec * timeInterval
            
            posX = (posX.magnitude > p_x.magnitude) ? playerAimArray[0].position.x : posX
            posY = (posY.magnitude > p_y.magnitude) ? playerAimArray[0].position.y : posY
            
            playerAimArray[0].position.x = posX
            playerAimArray[0].position.y = posY*/
            
            
            playerAimArray[0].position.x = max(min(playerAimArray[0].position.x + panVel.x, maxX), -maxX)
            playerAimArray[0].position.y = max(min(playerAimArray[0].position.y - panVel.y, maxY), -maxY)
            
            if panVel.x * panVel.x + panVel.y * panVel.y < 1 {
                panVel = CGPoint.zero
            }
            
            panVel.x = panVel.x * dampening
            panVel.y = panVel.y * dampening
        }
        
    }
    
    ///		Function that is called whenever there is a change in
    /// the controller motion, sets the aim new position based on
    /// the controller mode.
    ///
    /// - Parameters:
    ///   - motion: GCMotion
    func motionUpdate(motion: GCMotion) {
        
        if !controllerSwipeMode {
            let x = motion.gravity.x
            let y = -motion.gravity.y
            
            // values used to possibilitate the movement along all the screen
            let p_x:Double = PX
            let p_y:Double = PY
            let maxX = Double(self.size.width/2)
            let maxY = Double(self.size.height/2)
            
            
            let newX = min(p_x,max(-p_x,x)) / p_x * maxX
            let newY = min(p_y,max(-p_y,y)) / p_y * maxY
            //Movimento mais suave
            currentAimPosition = CGPoint(x: (newX + lastX)/2, y: (newY + lastY)/2)
            //Movimento direto
            //		currentAimPosition = CGPoint(x: newX, y: newY)
            
            lastX = newX
            lastY = newY
            
        } else {
            
            /// Swipe Config
            let x = CGFloat((motion.controller?.microGamepad?.dpad.xAxis.value)!)
            let y = CGFloat((motion.controller?.microGamepad?.dpad.yAxis.value)!)
            currentTouchPosition = CGPoint(x: x, y: y)

        }
    }
    
    /// Selects what control will be used.
    ///
    /// - Parameter typeOfControl: string that can be "swipe" or "motion" to select these two types of controls. Any other string passed as this parameter will have no effects
    func selectRemoteType(typeOfControl: String) {
        switch typeOfControl {
        case "swipe":
            self.controllerSwipeMode = true
        case "motion":
            self.controllerSwipeMode = false
        default:
            break
        }
    }
    
    /// returns the gameNode reference
    ///
    /// - Returns: gameNode
    func getGameNode() -> SKNode {
        return self.gameNode 
    }
    
    func panAim(_ sender: UIPanGestureRecognizer) {
        //print(sender.velocity(in: self.view))
        panVel = sender.velocity(in: self.view)
        
        panVel.x = panVel.x * (1 + abs(panVel.x * 0.0003)) * 0.001
        panVel.y = panVel.y * (1 + abs(panVel.y * 0.0003)) * 0.003
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UITapGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    /// removes all gestures from this view
    private func removeAllGestures() {
        if let view = self.view as UIView! {
            view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
        }
    }
}





















