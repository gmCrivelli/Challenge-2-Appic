//
//  targetController.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

let timeToDisappear : TimeInterval = 3.0
let numberOfSplashs = 4

class TargetController: NSObject {
    
    var screenSize : CGSize
    let radius : CGFloat = 30
    var gameNode : SKNode
    var left : CGFloat!
    var right : CGFloat!
    var top : CGFloat!
    var bottom : CGFloat!
    var targetArray = [Target]()
    var splashImagesArray = [String]()
    
    let hitAction:SKAction = SKAction.scale(by: 1.5, duration: 0.3)
    
    init (screenSize : CGSize, gameNode: SKNode) {
        self.screenSize = screenSize
        self.gameNode = gameNode
        self.left = self.radius - self.screenSize.width/2
        self.right = self.screenSize.width/2 - radius
        self.top = self.screenSize.height/2 - radius
        self.bottom = radius - self.screenSize.height/2
        for i in 1...numberOfSplashs {
            splashImagesArray.append("splash\(i).png")
        }
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
    
    func detectHit (_ location: CGPoint) {
        for t in self.targetArray {
            if t.targetNode.contains(location) {
                
                let randomSplash : Int = Int(arc4random_uniform(UInt32(numberOfSplashs)))
                
                let splashNode = SKSpriteNode(texture: SKTexture(imageNamed: splashImagesArray[randomSplash
                    ]))
                splashNode.size.height = self.radius*0.75
                splashNode.size.width = self.radius*0.75
                splashNode.colorBlendFactor = 1
                splashNode.color = .green
                t.targetNode.addChild(splashNode)
                let splashPosition = gameNode.convert(location, to: splashNode)
                splashNode.position = splashPosition
                splashNode.zPosition = 1
                
                let plokNode : SKEmitterNode! = SKEmitterNode(fileNamed: "Plok.sks")
                splashNode.addChild(plokNode)
                setupPlokNode(plokNode)
            }
        }
    }
    
    func setupPlokNode (_ plokNode : SKEmitterNode) {
        
        // center of splash
        plokNode.position = CGPoint(x: 0, y: 0)
        plokNode.particleColorSequence = nil
        plokNode.particleColor = .green
        plokNode.alpha = 0
        let sizePlok = self.radius
        plokNode.particleSize = CGSize(width: sizePlok, height: sizePlok)
    
        let waitAction = SKAction.wait(forDuration: 1)
        let appearAction = SKAction.run {
            plokNode.alpha = 1
        }
        let removePlokAction = SKAction.run {
            plokNode.removeFromParent()
        }
        
        plokNode.isUserInteractionEnabled = false
        
        // it makes the plok effect appear in the screen and after that it is removed
        plokNode.run(SKAction.sequence([appearAction, waitAction, appearAction.reversed(), removePlokAction]))
        
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
        let waitAction = SKAction.wait(forDuration: timeToDisappear)
        
        //        let moveToLeft = SKAction.moveTo(x: left, duration: 5)
        //        let moveToRight = SKAction.moveTo(x: right, duration: 5)
        
        //        if (foundedTarget.initialPosition == "left") {
        //            node.run(SKAction.sequence([waitAction, SKAction.repeatForever(SKAction.sequence([moveToRight, moveToLeft]))]))
        //        } else {
        //            node.run(SKAction.sequence([waitAction, SKAction.repeatForever(SKAction.sequence([moveToLeft, moveToRight]))]))
        //        }
        
        let timeFade = 0.5
        let disappearAction = SKAction.fadeOut(withDuration: timeFade)
        let moveToPosition = SKAction.run {
            let newX = self.random(min: self.left, max: self.right)
            let newY = self.random(min: self.bottom, max: self.top)
            foundedTarget.targetNode.position = CGPoint(x: newX, y: newY)
        }
        let appearAction = SKAction.fadeIn(withDuration: timeFade)
        node.run(SKAction.sequence([waitAction, SKAction.repeatForever(SKAction.sequence([disappearAction, moveToPosition, appearAction, waitAction]))]))
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
