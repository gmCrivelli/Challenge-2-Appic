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
    
    var targetController : TargetController!
    var gameNode = SKNode()
    var aimNode:SKSpriteNode!
    
    var maxX:CGFloat!
    var maxY:CGFloat!
    var currentAimPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    private var prevTilt : CGPoint = CGPoint.zero
    private var currentTilt : CGPoint = CGPoint.zero
    private var prevTouch : CGPoint!
    private var panVel : CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var tiltVel : CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var needsUpdatePan : Bool = false
    private let dampening:CGFloat = 0.87
    
    private let motionMovement:CGFloat = 100
    
    override func didMove(to view: SKView) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        
        gameNode = self.childNode(withName: "gameNode")!
        aimNode = gameNode.childNode(withName: "aim") as! SKSpriteNode
        targetController = TargetController(screenSize: self.size, gameNode: gameNode)

        let targetNode1 = targetController.addTarget(typeOfNode: "shape")
        targetController.moveBetweenSides(node: targetNode1)
        
        let targetNode2 = targetController.addTarget(typeOfNode: "sprite")
        targetController.moveBetweenSides(node: targetNode2)
        
        maxX = self.size.width/2
        maxY = self.size.height/2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectTapped(_:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue),NSNumber(value: UIPressType.select.rawValue)];
        tapGestureRecognizer.delegate = self
        self.view?.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panAim(_:)))
        panGestureRecognizer.delegate = self
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    func selectTapped(_ sender: UITapGestureRecognizer) {
        targetController.detectHit(aimNode.position)
    }
    
    func panAim(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            prevTilt = currentTilt
            needsUpdatePan = false
        case .ended:
            needsUpdatePan = true
        default:
            break
        }
        
        print(sender.velocity(in: self.view))
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.aimNode.position.x = max(min(self.aimNode.position.x + panVel.x + tiltVel.x * motionMovement, maxX), -maxX)
        self.aimNode.position.y = max(min(self.aimNode.position.y - panVel.y - tiltVel.y * motionMovement, maxY), -maxY)
        
        tiltVel = CGPoint.zero
        //if needsUpdatePan {
        
        if panVel.x * panVel.x + panVel.y * panVel.y < 1 {
            needsUpdatePan = false
            panVel = CGPoint.zero
        }
        panVel.x = panVel.x * dampening
        panVel.y = panVel.y * dampening
        
        /*}
        else{
            panVel = CGPoint.zero
        }*/
    }
    
    func motionUpdate(motion: GCMotion) {
        // Called whenever there is a change in the controller motion
        
        /// Motion Config
        //let x:CGFloat = CGFloat(motion.gravity.x)
        //let y:CGFloat = -(CGFloat)(motion.gravity.y)
        let p_x:CGFloat = 0.6
        let p_y:CGFloat = 0.35
        let g_x:CGFloat = CGFloat(motion.gravity.x) //min(max(CGFloat(motion.gravity.x), -p_x), p_x) / p_x
        let g_y:CGFloat = CGFloat(motion.gravity.y) //min(max(CGFloat(motion.gravity.y), -p_y), p_y) / p_y
        
        //currentAimPosition = CGPoint(x: min(p_x,max(-p_x,CGFloat(x))) / p_x * maxX, y: min(p_y,max(-p_y,CGFloat(y))) / p_y * maxY)
        
        tiltVel.x = g_x - prevTilt.x
        tiltVel.y = g_y - prevTilt.y
        prevTilt = CGPoint(x: g_x, y: g_y)
        currentTilt = prevTilt
        
        
        /// Swipe Config
        //let x = motion.controller?.microGamepad?.dpad.xAxis.value
        //let y = motion.controller?.microGamepad?.dpad.yAxis.value
        //currentAimPosition = (CGFloat(x!) * maxX, min(0.5,max(-0.5,CGFloat(y!))) * 2 * maxY)
        
        //currentAimPosition = (CGFloat() * maxX, min(0.5,max(-0.5,CGFloat())) * 2 * maxY)
        //print(motion.gravity)
        //print(motion.userAcceleration)
    }
}
