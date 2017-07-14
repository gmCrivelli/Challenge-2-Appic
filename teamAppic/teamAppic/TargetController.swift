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
	
	var backGroundAbout : Bool = false
	
    var debugging : Bool = false
    
    var entityManager : EntityManager!

    /// delegate to HUD
    public weak var delegateHud : HudProtocol?
    
    init (screenSize : CGSize, gameNode: SKNode, entityManager: EntityManager) {
        
        self.entityManager = entityManager
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
	
    func detectHit (_ location: CGPoint, player : Int) {
        // We do what we must.
        for t in Array(entityManager.entities).sorted(by: { t1, t2 in
            if let s1 = t1.component(ofType: SpriteComponent.self),
            let s2 = t2.component(ofType: SpriteComponent.self) {
                return s1.node.zPosition > s2.node.zPosition
            }
            else { return false }
        })
        
        {
            guard let spriteComponent = t.component(ofType: SpriteComponent.self),
                let typeComponent = t.component(ofType : TypeComponent.self) else { continue }
            
            if spriteComponent.node.contains(location) {
                
                let randomSplash : Int = Int(arc4random_uniform(UInt32(numberOfSplashs)))
				let convert = gameNode.convert(location, to: spriteComponent.node)
                
				var convertedLocation = CGPoint(x: convert.x, y: convert.y)
                
                print("HIT!", location, convertedLocation)
               
                print(spriteComponent.node.frame)
                
                let splash = Splash(imageNamed: splashImagesArray[randomSplash], targetRect: spriteComponent.size, splashPosition: convertedLocation, targetType: typeComponent.targetType)
				let splashNode = SKSpriteNode(texture: splash.splashTexture)

//                // these values must be the same of t.targetNode 
//                splashNode.size.height = self.radius*2
//                splashNode.size.width = self.radius*2
//                
                splashNode.colorBlendFactor = 1
                // player 1 color
                splashNode.color = PlayersColors.playerColor(player: 1)
				splashNode.zPosition = 0
                spriteComponent.node.addChild(splashNode)
	
                let randomSound: Int = Int(arc4random_uniform(UInt32(numberOfShootSounds)))
                splashNode.run(soundActions[randomSound])
                let plokNode : SKEmitterNode! = SKEmitterNode(fileNamed: "Plok.sks")
				convertedLocation.y = -convertedLocation.y
				plokNode.position = location
                gameNode.addChild(plokNode)
				setupPlokNode(plokNode,color: PlayersColors.playerColor(player: 1))
                // updating score of the player
                delegateHud?.updateScore(player: player)
				
				
				
				//Add the resize component
				let target = t as! Target
				if let related = target.relatedEntity{
					let relatedTarget = related as! Target
					let targetAnimateComponent = AnimationComponent(entityManager: entityManager, animationTime: 3,name: target.name)
					let relatedAnimateComponent = AnimationComponent(entityManager: entityManager, animationTime: 3,name: relatedTarget.name)
					target.addComponent(targetAnimateComponent)
					relatedTarget.addComponent(relatedAnimateComponent)
					entityManager.addAnimationComponent(target)
					entityManager.addAnimationComponent(relatedTarget)
				} else {
					let targetAnimateComponent = AnimationComponent(entityManager: entityManager, animationTime: 3,name: target.name)
					target.addComponent(targetAnimateComponent)
					entityManager.addAnimationComponent(target)
				}
				
				
				
                return
            }
        }
    }
	
	func addSplashToTarget(node: SKSpriteNode, position: CGPoint) {
		
		let randomSplash : Int = Int(arc4random_uniform(UInt32(numberOfSplashs)))
		let convert = gameNode.convert(position, to: node)
		var convertedLocation = CGPoint(x: convert.x, y: convert.y)
		let texture = SKTexture(imageNamed: splashImagesArray[randomSplash])
		let splashNode = SKSpriteNode(texture: texture)
		
		splashNode.position = convertedLocation
		splashNode.size.height = self.radius*2
		splashNode.size.width = self.radius*2
		splashNode.colorBlendFactor = 1
		let color = randomColor()
		splashNode.color = color
		splashNode.zPosition = 1
		node.addChild(splashNode)
		
		let desapearAction = SKAction.fadeAlpha(to: 0, duration: 3)
		let removeAction = SKAction.run {
			splashNode.removeAllActions()
			splashNode.removeFromParent()
		}
		let randomSound: Int = Int(arc4random_uniform(UInt32(numberOfShootSounds)))
		let randomSoundAction = soundActions[randomSound]
		let sequenceAction = SKAction.sequence([randomSoundAction, desapearAction, removeAction])
		splashNode.run(sequenceAction)
		
		let plokNode : SKEmitterNode! = SKEmitterNode(fileNamed: "Plok.sks")
		convertedLocation.y = -convertedLocation.y
		plokNode.position = position
		
		gameNode.addChild(plokNode)
		setupPlokNode(plokNode, color: color)
	}
	
	func randomColor() -> UIColor {
		let randRed:CGFloat = CGFloat(Float(arc4random_uniform(100))/100.0)
		let randGreen:CGFloat = CGFloat(Float(arc4random_uniform(100))/100.0)
		let randBlue:CGFloat = CGFloat(Float(arc4random_uniform(100))/100.0)
		let color = UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: 1)
		return color
	}
	
	func setupPlokNode (_ plokNode : SKEmitterNode, color: UIColor) {
        let timePlok : TimeInterval = 0.3
        // center of splash
        plokNode.particleColorSequence = nil
        // player 1 color
		plokNode.particleColor = color
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
    
//    /// determines the initial position of target
//    ///
//    /// - Parameter targetNode: target node that will have its initial position setted
//    /// - Returns: returns the initial side
//	private func chooseTargetPosition (backGround : Bool, targetNode: SKNode) -> String {
//        var edge : Int
//        if (self.debugging) {
//            // Determine where to spawn the ball along the Y axis
//            edge = Int(arc4random_uniform(2))
//        } else {
//            edge = -1
//        }
//		
//		if (backGround) {
//			edge = -1
//		}
//		
//        var initialSide : String = ""
//        
//        var actualX:CGFloat = 0
//        var actualY:CGFloat = 0
//        
//        switch edge {
//        // left
//        case 0:
//            initialSide = "left"
//            actualX = left
//            actualY = random(min: bottom, max: top)
//        // right
//        case 1:
//            initialSide = "right"
//            actualX = right
//            actualY = random(min: bottom, max: top)
//            
//            //        case 2:
//            //            actualX = random(min: left, max: right)
//            //            actualY = top
//            //
//            //        case 3:
//            //            actualX = random(min: left, max: right)
//            //            actualY = bottom
//    
//        // mid center
//        default:
//            initialSide = "mid"
//            actualX = 0
//            actualY = 0
//        }
//        
//        targetNode.position = CGPoint(x: actualX, y: actualY)
//        return initialSide
//    }
    
    
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
