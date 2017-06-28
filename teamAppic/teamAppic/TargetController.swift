//
//  targetController.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

class TargetController: NSObject {
   
    var screenSize : CGSize
    let radius : CGFloat = 30
    var gameNode : SKNode
    
    init (screenSize : CGSize, gameNode: SKNode) {
        self.screenSize = screenSize
        self.gameNode = gameNode
    }
    
    func addTarget (typeOfNode : String) -> SKNode {
        var targetNode : SKNode
        if (typeOfNode == "shape") {
            targetNode = SKShapeNode(circleOfRadius: radius)
            self.gameNode.addChild(targetNode)
        }
        else {
            targetNode = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
            let targetNodeSprite = targetNode as! SKSpriteNode
            targetNodeSprite.size.height = self.radius*2
            targetNodeSprite.size.width = self.radius*2
            self.gameNode.addChild(targetNodeSprite)
        }
        
        chooseTargetPosition(targetNode: targetNode)
        setTargetTexture(node: targetNode, color: .blue)
        
        return targetNode
    }
    
    func setTargetTexture (node : SKNode, color : UIColor) {
        if (node is SKShapeNode) {
            let nodeShape = node as! SKShapeNode
            nodeShape.fillColor = color
        }
    }
    
    func moveTarget (targetNode : SKNode) {
        let left = self.radius - self.screenSize.width/2
        let right = self.screenSize.width/2 - radius
        let moveLeft = SKAction.moveTo(x: left, duration: 5)
        let moveRight = SKAction.moveTo(x: right, duration: 5)
        
        targetNode.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
    }
    
    private func chooseTargetPosition (targetNode: SKNode){
        // Determine where to spawn the ball along the Y axis
        let edge = arc4random_uniform(2)
        
        let left = self.radius - self.screenSize.width/2
        let right = self.screenSize.width/2 - radius
        let top = self.screenSize.height/2 - radius
        let bottom = radius - self.screenSize.height/2
        
        var actualX:CGFloat = 0
        var actualY:CGFloat = 0
        
        switch edge {
        // left
        case 0:
            actualX = left
            actualY = random(min: bottom, max: top)
        // right
        case 1:
            actualX = right
            actualY = random(min: bottom, max: top)
            
//        case 2:
//            actualX = random(min: radius - self.screenSize.width/2, max: self.screenSize.width/2 - self.radius)
//            actualY = self.screenSize.height/2
//            
//        case 3:
//            actualX = random(min: self.radius - self.screenSize.width/2, max: self.screenSize.width/2 - self.radius)
//            actualY = -self.screenSize.height/2
//            
        default:
            break
        }
        
        targetNode.position = CGPoint(x: actualX, y: actualY)
        
    }
    
    
    /// returns a random float value from 0 to 1
    ///
    /// - Returns: random float value from 0 to 1
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    
    /// returns a random value float from min to max
    ///
    /// - Parameters:
    ///   - min: min float value
    ///   - max: max float value
    /// - Returns: random value float from min to max
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let randomValue = random() * (max - min) + min
        return randomValue
    }
}
