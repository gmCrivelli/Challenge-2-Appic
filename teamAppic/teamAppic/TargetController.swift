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
let numberOfShootSounds = 3

public protocol HudProtocol : NSObjectProtocol {
    /// function to updates the player score
    ///
    /// - Parameter player: player which score will be increased
    func updateScore(player : Int)
}

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

    var soundActions = [SKAction]()
    
    let hitAction:SKAction = SKAction.scale(by: 1.5, duration: 0.3)
    
    var debugging : Bool = false

    /// delegate to HUD
    public weak var delegateHud : HudProtocol?
    
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
        
        for i in 1...numberOfShootSounds {
            soundActions.append(SKAction.playSoundFileNamed("shoot\(i).mp3", waitForCompletion: false))
        }
    }
    
    func addTarget (debugging : Bool, typeOfNode : String) -> SKNode {
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
        
        self.debugging = debugging
        
        return targetNode
    }
    
    func detectHit (_ location: CGPoint, player : Int) {
        for t in self.targetArray {
            if t.targetNode.contains(location) {
				
                let randomSplash : Int = Int(arc4random_uniform(UInt32(numberOfSplashs)))
				let convert = gameNode.convert(location, to: t.targetNode)
				
				var convertedLocation = CGPoint(x: convert.x, y: convert.y)
				let splash = Splash(imageNamed: splashImagesArray[randomSplash], targetRect: t.targetNode.frame, splashPosition: convertedLocation)
				let splashNode = SKSpriteNode(texture: splash.splashTexture)

                // these values must be the same of t.targetNode 
                splashNode.size.height = self.radius*2
                splashNode.size.width = self.radius*2
                
                splashNode.colorBlendFactor = 1
                // player 1 color
                splashNode.color = PlayersColors.playerColor(player: 1)
				splashNode.zPosition = 1
                t.targetNode.addChild(splashNode)
	
                let randomSound: Int = Int(arc4random_uniform(UInt32(numberOfShootSounds)))
                splashNode.run(soundActions[randomSound])
                let plokNode : SKEmitterNode! = SKEmitterNode(fileNamed: "Plok.sks")
				convertedLocation.y = -convertedLocation.y
				plokNode.position = location
                gameNode.addChild(plokNode)
                setupPlokNode(plokNode)
                
                // updating score of the player
                delegateHud?.updateScore(player: player)
            }
        }
    }
    
    func setupPlokNode (_ plokNode : SKEmitterNode) {
        let timePlok : TimeInterval = 0.3
        // center of splash
        plokNode.particleColorSequence = nil
        // player 1 color
        plokNode.particleColor = PlayersColors.playerColor(player: 1)
        plokNode.alpha = 0
        let sizePlok = self.radius
        plokNode.particleSize = CGSize(width: sizePlok, height: sizePlok)
    
        let waitAction = SKAction.wait(forDuration: timePlok)
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
        if (!self.debugging) {
            node.run(SKAction.sequence([waitAction, SKAction.repeatForever(SKAction.sequence([disappearAction, moveToPosition, appearAction, waitAction]))]))
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
        var edge : Int
        if (self.debugging) {
            // Determine where to spawn the ball along the Y axis
            edge = Int(arc4random_uniform(2))
        } else {
            edge = -1
        }
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
    
        // mid center
        default:
            initialSide = "mid"
            actualX = 0
            actualY = 0
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
