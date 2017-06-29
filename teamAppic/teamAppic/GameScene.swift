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
    
    var targetController : TargetController!
    var gameNode = SKNode()
    var aimNode:SKSpriteNode!
    
    var maxX:CGFloat!
    var maxY:CGFloat!
    var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override func didMove(to view: SKView) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        
        gameNode = self.childNode(withName: "gameNode")!
        aimNode = gameNode.childNode(withName: "aim") as! SKSpriteNode
        targetController = TargetController(screenSize: self.size, gameNode: gameNode)

        // 
        let targetNode1 = targetController.addTarget(typeOfNode: "shape")
        targetController.moveBetweenSides(node: targetNode1)
        
        let targetNode2 = targetController.addTarget(typeOfNode: "sprite")
        targetController.moveBetweenSides(node: targetNode2)
        
        maxX = self.size.width/2
        maxY = self.size.height/2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
        let pressType = UIPressType.select
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)];
        self.view?.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func selectTapped(_ sender: UITapGestureRecognizer) {
        targetController.detectHit(aimNode.position)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        aimNode.removeAllActions()
        //aimNode.run(SKAction.move(to: currentAimPosition, duration: ))
        
        aimNode.position = currentAimPosition
    }
    
    
    func motionUpdate(motion: GCMotion) {
        // Called whenever there is a change in the controller motion
        
        /// Motion Config
        let x = motion.gravity.x
        let y = -motion.gravity.y
        let p_x:CGFloat = 0.7
        let p_y:CGFloat = 0.35
        
        currentAimPosition = CGPoint(x: min(p_x,max(-p_x,CGFloat(x))) / p_x * maxX,
                              y: min(p_y,max(-p_y,CGFloat(y))) / p_y * maxY)
        
        /// Swipe Config
        //let x = motion.controller?.microGamepad?.dpad.xAxis.value
        //let y = motion.controller?.microGamepad?.dpad.yAxis.value
        //currentAimPosition = (CGFloat(x!) * maxX, min(0.5,max(-0.5,CGFloat(y!))) * 2 * maxY)
        
        //currentAimPosition = (CGFloat() * maxX, min(0.5,max(-0.5,CGFloat())) * 2 * maxY)
        //print(motion.gravity.x, motion.gravity.y)
    }
}
