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
    var left : CGFloat!
    var right : CGFloat!
    var top : CGFloat!
    var bottom : CGFloat!
    var targetArray = [Target]()
    
    init (screenSize : CGSize, gameNode: SKNode) {
        self.screenSize = screenSize
        self.gameNode = gameNode
        self.left = self.radius - self.screenSize.width/2
        self.right = self.screenSize.width/2 - radius
        self.top = self.screenSize.height/2 - radius
        self.bottom = radius - self.screenSize.height/2
    }
    
    func addTarget (typeOfNode : String) -> SKNode {
        var targetNode : SKNode
        
        switch typeOfNode {
        case "shape":
            targetNode = SKShapeNode(circleOfRadius: radius)
            self.gameNode.addChild(targetNode)
        default:
            targetNode = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
            let targetNodeSprite = targetNode as! SKSpriteNode
            targetNodeSprite.size.height = self.radius*2
            targetNodeSprite.size.width = self.radius*2
            self.gameNode.addChild(targetNodeSprite)
        }
        
        let initialSide = chooseTargetPosition(targetNode: targetNode)
        let target = Target(node: targetNode, initialPosition: initialSide)
        targetArray.append(target)
        setTargetColor(node: targetNode, color: .blue)
        
        return targetNode
    }
    
    
    /// sets the color of a target if it is a SKShapeNode
    ///
    /// - Parameters:
    ///   - node: node that will be colorized
    ///   - color: color in which node will be colorized
    func setTargetColor (node : SKNode, color : UIColor) {
        if (node is SKShapeNode) {
            let nodeShape = node as! SKShapeNode
            nodeShape.fillColor = color
        }
    }
    
    /// moves node from onde side to another
    ///
    /// - Parameter node: node which will be moved
    func moveBetweenSides (node : SKNode) {
        
        let foundedTarget = findTargetInArray(node: node)
        
        let moveToLeft = SKAction.moveTo(x: left, duration: 5)
        let moveToRight = SKAction.moveTo(x: right, duration: 5)
        let waitAction = SKAction.wait(forDuration: 2)
        
        if (foundedTarget.initialPosition == "left") {
            node.run(SKAction.repeatForever(SKAction.sequence([waitAction, moveToRight, moveToLeft])))
        } else {
            node.run(SKAction.repeatForever(SKAction.sequence([waitAction, moveToLeft, moveToRight])))
        }
    }
    
    func findTargetInArray (node : SKNode) -> Target {
        var foundedTarget : Target?
        for target in targetArray {
            if (target.targetNode == node) {
                foundedTarget = target
            }
        }
        return foundedTarget!
    }
    
    /// determines the initial position of target
    ///
    /// - Parameter targetNode: target node that will have its initial position setted
    /// - Returns: returns the initial side
    private func chooseTargetPosition (targetNode: SKNode) -> String {
        // Determine where to spawn the ball along the Y axis
        let edge = arc4random_uniform(2)
        var initialSide : String = ""
        
        var actualX:CGFloat = 0
        var actualY:CGFloat = 0
        
        switch edge {
        // left
        case 0:
            initialSide = "left"
            actualX = left
            actualY = random(min: bottom, max: top)
        // right
        case 1:
            initialSide = "right"
            actualX = right
            actualY = random(min: bottom, max: top)
            
//        case 2:
//            actualX = random(min: left, max: right)
//            actualY = top
//            
//        case 3:
//            actualX = random(min: left, max: right)
//            actualY = bottom
//            
        default:
            break
        }
        
        targetNode.position = CGPoint(x: actualX, y: actualY)
        return initialSide
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
