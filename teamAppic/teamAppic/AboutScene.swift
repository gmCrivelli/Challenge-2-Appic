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

class AboutScene: SKScene, ReactToMotionEvents {
	//Nodes and TargetController
	var gameNode = SKNode()
	var pauseNode = SKSpriteNode()
	var targetController : TargetController!
	//Controller mode
	var controllerSwipeMode: Bool = false
	//Positions
	var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
	var currentTouchPosition: CGPoint! = CGPoint(x: 0.0, y: 0.0)
	//Motion update
	var lastX: Double! = 0
	var lastY : Double! = 0
	
	var playerAim: SKSpriteNode!
	var backgroundTarget: Target!
    
    var lastUpdateTimeInterval : TimeInterval = 0
    var entityManager: EntityManager!
	
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
	}
	
	///		Setup the Scenes.
	///
	func setupScenes(){
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.motionDelegate = self
	}
	
	///		Setup the Nodes.
	///
	func setupNodes(){
		self.gameNode = self.childNode(withName: "gameNode")!
		
		playerAim = gameNode.childNode(withName: "aim1") as! SKSpriteNode
		
//		let targetNode1 = targetController.addTarget(debugging: true, typeOfNode: "shape")
//		targetController.moveBetweenSides(node: targetNode1)
		
		let backgroundSpriteNode = gameNode.childNode(withName: "backgroundTarget") as! SKSpriteNode
        backgroundTarget = Target(targetType: .type1, moveType: .gravity, maxSpeed: 0.0, maxAccel: 0.0, entityManager: entityManager)
        backgroundTarget.component(ofType: SpriteComponent.self)?.node = backgroundSpriteNode
	}
    
    func setupEntities() {
        entityManager = EntityManager(scene: self)
        
        targetController = TargetController(screenSize: self.size, gameNode: gameNode, entityManager: entityManager)
    }
	
	///		Setup the gestures.
	///
	func setupGestures(){
		let selectGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
		let pressType = UIPressType.select
		selectGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
		self.view?.addGestureRecognizer(selectGestureRecognizer)
	}
	
	///		Function that catches the Gesture for tap in
	///	in the controller, executes the target controller
	///	detectHit function.
	///
	/// - Parameters:
	///   - sender: UITapGestureRecognizer
	func selectTapped(_ sender: UITapGestureRecognizer) {
//		if (!self.gameNode.isPaused) {
//			targetController.detectHit(playerAim.position, player: 0)
//		}
        targetController.addSplashToEntity(entity: backgroundTarget, position: playerAim.position)
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
		//playerAim.removeAllActions()
		
		if !controllerSwipeMode {
			playerAim.position = currentAimPosition
			
		} else {
			
			let currToPosX = self.currentTouchPosition.x
			let currToPosY = self.currentTouchPosition.y
			
			let movementPerSec:CGFloat = 750.0
			
			let p_x:CGFloat = 450
			let p_y:CGFloat = 300
			
			var posX = playerAim.position.x + currToPosX * movementPerSec * CGFloat(deltaTime)
			var posY = playerAim.position.y + currToPosY * movementPerSec * CGFloat(deltaTime)
			
			posX = (posX.magnitude > p_x.magnitude) ? playerAim.position.x : posX
			posY = (posY.magnitude > p_y.magnitude) ? playerAim.position.y : posY
			
			playerAim.position.x = posX
			playerAim.position.y = posY
			
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


























