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

class GameScene: SKScene, ReactToMotionEvents, GameSceneProtocol {
    
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
	
	var duckTarget : DoublePatternCannon!

    
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
        MusicManager.instance.setupGame()
        MusicManager.instance.playGameAudio()
    }
    
    /// Setups the game over configurations
    func gameOverSetups() {
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
        
//        let cannon1 = PatternCannon(baseLocation: CGPoint(x: -500, y: -500),
//                                    cannonStep: CGPoint(x: 100, y: 0),
//                                    numberOfTargets: 10,
//                                    targetScale: 0.7,
//                                    targetTypeArray: [TargetType.target],
//                                    baseTargetSpeed: float2(x: 0, y: 500),
//                                    baseTargetAccel: float2(x: 0, y: -100),
//                                    timeDelayArray: [0.3],
//                                    entityManager: entityManager)
		
		//Duck with Stick implementation
//		let _ = PatternCannon(baseLocation: CGPoint(x: -960, y: -300),
//								cannonStep: CGPoint(x: 0, y: 0),
//								numberOfTargets: 10,
//								targetScale: 1.0,
//								targetTypeArray: [TargetType.stick],
//								baseTargetSpeed: float2(x: 500, y: 0),
//								baseTargetAccel: float2(x: 0, y: 0),
//								timeDelayArray: [DuckMovement.targetTravelTime * 1.2],
//								entityManager: entityManager)
//		
//        let _ = PatternCannon(baseLocation: CGPoint(x: -960, y: -200),
//								cannonStep: CGPoint(x: 0, y: 0),
//								numberOfTargets: 10,
//								targetScale: 1.0,
//								targetTypeArray: [TargetType.duck],
//								baseTargetSpeed: float2(x: 500, y: 0),
//								baseTargetAccel: float2(x: 0, y: 0),
//								timeDelayArray: [DuckMovement.targetTravelTime * 1.2],
//								entityManager: entityManager)

		
		self.duckTarget = DoublePatternCannon(firstBaseLocation: CGPoint(x: -960, y: -300),
		                                      secondBaseLocation: CGPoint(x: -960, y: -200),
		                                      cannonStep: CGPoint(x: 0, y: 0),
		                                      numberOfTargets: 1,
		                                      targetScale: 1.0,
		                                      firstTargetTypeArray: [TargetType.stick],
		                                      secondTargetTypeArray: [TargetType.duck],
		                                      baseTargetSpeed: float2(x: 500, y: 0),
		                                      baseTargetAccel: float2(x: 0, y: 0),
		                                      timeDelayArray: [DuckMovement.targetTravelTime * 1.2],
		                                      entityManager: entityManager)

//        let cannon3 = PatternCannon(baseLocation: CGPoint(x: -960, y: -300),
//                                    cannonStep: CGPoint(x: 0, y: 50),
//                                    numberOfTargets: 80,
//                                    targetScale: 0.5,
//                                    targetTypeArray: [TargetType.target],
//                                    baseTargetSpeed: float2(x: 400, y: 300),
//                                    baseTargetAccel: float2(x: 0, y: -100),
//                                    timeDelayArray: [0.5],
//                                    entityManager: entityManager)

//        let _ = PatternCannon(baseLocation: CGPoint(x: 960, y: -300),
//                                    cannonStep: CGPoint(x: 0, y: 50),
//                                    numberOfTargets: 5,
//                                    targetScale: 0.5,
//                                    targetTypeArray: [TargetType.target],
//                                    baseTargetSpeed: float2(x: -400, y: 300),
//                                    baseTargetAccel: float2(x: 0, y: -100),
//                                    timeDelayArray: [0.5],
//                                    entityManager: entityManager)
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
        
        // instantiating the number of ducks and sticks
        let NUMBEROFDUCKS = 1
        let action = SKAction.run {
            self.duckTarget.launchTarget()
        }
        let waitAction = SKAction.wait(forDuration: (self.duckTarget.timeDelayArray[self.duckTarget.launchedCounter % self.duckTarget.timeDelayArray.count]))
        self.run(SKAction.repeat(SKAction.sequence([action,waitAction]), count: NUMBEROFDUCKS))
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
			
			let currToPosX = self.currentTouchPosition.x
			let currToPosY = self.currentTouchPosition.y
			
			let movementPerSec:CGFloat = 750.0
			let timeInterval: CGFloat = 1.0/60.0
			
			let p_x:CGFloat = self.size.width/2
			let p_y:CGFloat = self.size.height/2
			
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
}




























