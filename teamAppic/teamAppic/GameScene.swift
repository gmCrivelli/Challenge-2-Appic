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

class GameScene: SKScene, ReactToMotionEvents {
	//Nodes and TargetController
    var gameNode = SKNode()
    var aimNode:SKSpriteNode!
	var targetController : TargetController!
	//Controller mode
	var controllerSwipeMode: Bool = false
	//Positions
	var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
	var currentTouchPosition: CGPoint! = CGPoint(x: 0.0, y: 0.0)
	//Motion update
	var lastX: Double! = 0
	var lastY : Double! = 0
	
	///		Called after moving to the View,
	///	call all setup Functions.
	///
	/// - Parameters:
	///   - view: SKView
    override func didMove(to view: SKView) {
		setupScenes()
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
		gameNode = self.childNode(withName: "gameNode")!
		aimNode = gameNode.childNode(withName: "aim") as! SKSpriteNode
		
		targetController = TargetController(screenSize: self.size, gameNode: gameNode)
		
		let targetNode1 = targetController.addTarget(typeOfNode: "shape")
		targetController.moveBetweenSides(node: targetNode1)
		
		let targetNode2 = targetController.addTarget(typeOfNode: "sprite")
		targetController.moveBetweenSides(node: targetNode2)
	}
	
	///		Setup the gestures.
	///
	func setupGestures(){
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
		let pressType = UIPressType.select
		tapGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
		self.view?.addGestureRecognizer(tapGestureRecognizer)
	}
	
	///		Function that catches the Gesture for tap in
	///	in the controller, executes the target controller 
	///	detectHit function.
	///
	/// - Parameters:
	///   - sender: UITapGestureRecognizer
    func selectTapped(_ sender: UITapGestureRecognizer) {
        targetController.detectHit(aimNode.position)
    }
	
	///		Override of the function Update, called 
	///	every frame update, sets the aim new position 
	///	based on the controller mode.
	///
	/// - Parameters:
	///   - currentTime: TimeInterval
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        aimNode.removeAllActions()

		if !controllerSwipeMode {
			
			aimNode.position = currentAimPosition
			
		} else {
			
			let currToPosX = self.currentTouchPosition.x * CGFloat(Double.pi/180.0)
			let currToPosY = self.currentTouchPosition.y * CGFloat(Double.pi/180.0)
			
			let movementPerSec:CGFloat = 100
			let timeInterval: CGFloat! = 0.016666
			
			aimNode.position.x += currToPosX * movementPerSec * CGFloat(timeInterval)
			aimNode.position.y -= currToPosY * movementPerSec * CGFloat(timeInterval)
			
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
			
			///
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




























