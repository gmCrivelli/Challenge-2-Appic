//
//  GameScene.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var targetController : TargetController!
    var gameNode = SKNode()
    
    override func didMove(to view: SKView) {
        gameNode = self.childNode(withName: "gameNode")!
        targetController = TargetController(screenSize: self.size, gameNode: gameNode)
        
        // 
        let targetNode1 = targetController.addTarget(typeOfNode: "shape")
        targetController.moveTarget(targetNode: targetNode1)
        
        let targetNode2 = targetController.addTarget(typeOfNode: "sprite")
        targetController.moveTarget(targetNode: targetNode2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
