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

class GameScene: SKScene, ReactToMotionEvents, UIGestureRecognizerDelegate {
    
    let music = SKAudioNode(fileNamed: "sound.mp3")
    
	//Nodes and TargetController
    var gameNode = SKNode()
    var aimNode = SKSpriteNode()
    var pauseNode = SKSpriteNode()
	var targetController : TargetController!
    // Hud
    let hudController = HudController.hudInstance
	//Controller mode
	var controllerSwipeMode: Bool = false
	//Positions
	var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
	var currentTouchPosition: CGPoint! = CGPoint(x: 0.0, y: 0.0)
	//Motion update
	var lastX: Double! = 0
	var lastY : Double! = 0
    
    private var prevTilt : CGPoint = CGPoint.zero
    private var currentTilt : CGPoint = CGPoint.zero
    private var prevTouch : CGPoint!
    private var panVel : CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var tiltVel : CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var needsUpdatePan : Bool = false
    private let dampening:CGFloat = 0.87
    
    private let motionMovement:CGFloat = 100
    
    var lastUpdateTimeInterval : TimeInterval = 0
    var entityManager: EntityManager!

    // this two array must have the same length
    var playerNameArray = [String]()
    var playerAimArray = [SKSpriteNode]()
	
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
	
    func setupEntities() {
        
        entityManager = EntityManager(scene: self)
        
        targetController = TargetController(screenSize: self.size, gameNode: gameNode, entityManager: entityManager)
        
        let cannon1 = PatternCannon(baseLocation: CGPoint(x: 50, y: -100),
                                    cannonStep: CGPoint(x: 100, y: 0),
                                    numberOfTargets: 5,
                                    targetScale: 0.3,
                                    targetTypeArray: [TargetType.type1],
                                    baseTargetSpeed: float2(x: 0, y: 500),
                                    baseTargetAccel: float2(x: 0, y: -100),
                                    timeDelayArray: [0.0],
                                    entityManager: entityManager)
        
        let cannon2 = PatternCannon(baseLocation: CGPoint(x: -50, y: 50),
                                    cannonStep: CGPoint(x: 0, y: 150),
                                    numberOfTargets: 8,
                                    targetScale: 0.25,
                                    targetTypeArray: [TargetType.type1],
                                    baseTargetSpeed: float2(x: 500, y: 200),
                                    baseTargetAccel: float2(x: 0, y: -100),
                                    timeDelayArray: [0.0],
                                    entityManager: entityManager)
        
        let cannon3 = PatternCannon(baseLocation: CGPoint(x: self.size.width + 50, y: 50),
                                    cannonStep: CGPoint(x: 0, y: 150),
                                    numberOfTargets: 8,
                                    targetScale: 0.25,
                                    targetTypeArray: [TargetType.type1],
                                    baseTargetSpeed: float2(x: -500, y: 200),
                                    baseTargetAccel: float2(x: 0, y: -100),
                                    timeDelayArray: [0.0],
                                    entityManager: entityManager)
    }
    
    /// setups the circus music when the game is being played
    func setupMusics() {
        MusicManager.instance.setup()
        MusicManager.instance.play()
    }
    
    /// setups the game over configurations
    func gameOverSetups() {
        MusicManager.instance.stop()
        // sures that every node will be removed when the game overs or menu is selected
        self.gameNode.removeAllChildren()
        self.gameNode.removeFromParent()
    }
    
	///		Setup the Scenes.
	///
	func setupScenes() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.motionDelegate = self
	}
	
	///		Setup the Nodes.
	///
	func setupNodes(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        
		self.gameNode = self.childNode(withName: "gameNode")!
        self.pauseNode = self.childNode(withName: "pauseNode") as! SKSpriteNode
        
        // initializing player array and aim array (single player for now)
        playerNameArray = ["Player 1"]
        playerAimArray = [gameNode.childNode(withName: "aim1") as! SKSpriteNode]
        
        self.targetController.delegateHud = self.hudController

        // insert players (single player)
        hudController.insertPlayers(playerNameArray: playerNameArray, playerAimArray: playerAimArray)
		hudController.setHUD(gameNode: gameNode)
	}

	func setupGestures(){
		let selectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
		let pressType = UIPressType.select
        selectGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
		self.view?.addGestureRecognizer(selectGestureRecognizer)
        
        let pauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pauseTapped(_:)))
        let pauseType = UIPressType.playPause
        pauseGestureRecognizer.allowedPressTypes = [NSNumber(value: pauseType.rawValue)];
        self.view?.addGestureRecognizer(pauseGestureRecognizer)
	}
	
	///		Function that catches the Gesture for tap in
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
            targetController.detectHit(playerAimArray[0].position, player: 0)
        }
    }

    /// catches the gesture for pause in the tv control and pauses the game
    ///
    /// - Parameter sender: UITapGestureRecognizer
    func pauseTapped(_ sender : UITapGestureRecognizer) {
        self.isPaused = !(self.isPaused)
        if (self.isPaused) {
            self.hudController.timer.pauseTimer()
            self.pauseNode.alpha = 1
            self.gameNode.alpha = 0.3
        } else {
            self.hudController.timer.resumeTimer()
            self.pauseNode.alpha = 0
            self.gameNode.alpha = 1
        }

        print("The game will be paused")
    }
	
	///		Override of the function Update, called 
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
			
			let currToPosX = self.currentTouchPosition.x
			let currToPosY = self.currentTouchPosition.y
			
			let movementPerSec:CGFloat = 750.0
			let timeInterval: CGFloat = 1.0/60.0
			
			let p_x:CGFloat = 450
			let p_y:CGFloat = 300
			
			var posX = playerAimArray[0].position.x + currToPosX * movementPerSec * timeInterval
			var posY = playerAimArray[0].position.y + currToPosY * movementPerSec * timeInterval
			
			posX = (posX.magnitude > p_x.magnitude) ? playerAimArray[0].position.x : posX
			posY = (posY.magnitude > p_y.magnitude) ? playerAimArray[0].position.y : posY

			playerAimArray[0].position.x = posX
			playerAimArray[0].position.y = posY
			
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
			let p_x:Double = 0.7
			let p_y:Double = 0.35
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
}




























