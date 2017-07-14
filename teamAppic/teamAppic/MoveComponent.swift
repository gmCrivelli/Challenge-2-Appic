//
//  MoveComponent.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum MoveType : Int {
   // case followAgent = 1
    case noGravity = 1
    case gravity = 2
    case path = 3
}

class MoveComponent : GKComponent {
    
    var entityManager : EntityManager
    var moveType : MoveType
    var path : GKPath!
    var speedVector = float2(x: 0, y: 0)
    var accelVector = float2(x: 0, y: -250)
    var newPosition = float2(x: 0, y: 0)
    var maxSpeed : Float!
    var maxAcceleration : Float!
    var radius : Float!
    var mass : Float = 0.01
    
    var lifeTime : Double = 0
    
    init(maxSpeed: Float?, maxAcceleration: Float?, radius: Float, moveType: MoveType, entityManager: EntityManager) {
        
        self.entityManager = entityManager
        self.moveType = moveType
        super.init()
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.01
        
        if moveType == .noGravity {
            self.moveType = .gravity
            accelVector = float2(x: 0.0, y: 0.0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPath(path: GKPath) {
        self.path = path
    }
    
    func setSpeedVector(speedVector: float2) {
        self.speedVector = speedVector
    }
    
    func setAccelVector(accelVector: float2) {
        self.accelVector = accelVector
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    
        super.update(deltaTime: seconds)
        
        lifeTime += seconds
        
        switch moveType {
            
        //case .path:
            //FOLLOW PATH MOVEMENT
//            guard let entity = entity,
//                let typeComponent = entity.component(ofType: TypeComponent.self) else {
//                    return
//            }
//            
//            guard let movePath = path else { return }
//            
//            behavior = PathBehavior(targetSpeed: maxSpeed, path: movePath, forward: true, avoid: [])
//
        case .gravity:
            guard let entity = entity,
                let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
                    return
            }
            spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x + CGFloat(speedVector.x) * CGFloat(seconds),
                                      y: spriteComponent.node.position.y + CGFloat(speedVector.y) * CGFloat(seconds))
            speedVector = float2(x: speedVector.x + accelVector.x * Float(seconds),
                                 y: speedVector.y + accelVector.y * Float(seconds))
            
            if lifeTime > 1.5 && !entityManager.scene.intersects(spriteComponent.node) {
                entityManager.remove(entity)
            }
            
        default: break
        }
    }
    
}

class DuckMovement : GKComponent {
    
    static var targetTravelTime: TimeInterval = 2
    
    let entityManager : EntityManager
    
    var duckSpeed : Float = 300
    
    init(duckSpeed : Float, entityManager : EntityManager) {
        
        self.entityManager = entityManager
        self.duckSpeed = duckSpeed
        super.init()
    }
    
    func run() {
        guard let entity = entity,
            let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
                print("Ducks must have a sprite component!")
                return
        }
        
        //Move target foward with easy in easy out
        let moveFowardAction = SKAction.moveBy(x: CGFloat(duckSpeed), y: 0, duration: DuckMovement.targetTravelTime)
        moveFowardAction.timingMode = .easeInEaseOut
        //target wait for small duration
        let waitAction = SKAction.wait(forDuration: DuckMovement.targetTravelTime * 0.2)
        
        //Action block for target removal
        let removeAction = SKAction.run {
            if !self.entityManager.scene.intersects(spriteComponent.node){
                spriteComponent.node.removeAllChildren()
                self.entityManager.remove(entity)
            }
        }
        
        //Action Sequence
        let sequenceAction = SKAction.sequence([waitAction, moveFowardAction, removeAction])
        //run action
        spriteComponent.node.run(SKAction.repeatForever(sequenceAction))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StickMovement : GKComponent {
	
	static var targetTravelTime: TimeInterval = 2
	
	let entityManager : EntityManager
	
	init(entityManager : EntityManager) {
		
		self.entityManager = entityManager
		super.init()
	}
	
	func run() {
		guard let entity = entity,
			let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
				print("Sticks must have a sprite component!")
				return
		}
		
		//Move target foward with easy in easy out
		let moveFowardAction = SKAction.moveBy(x: 300, y: 0, duration: StickMovement.targetTravelTime)
		moveFowardAction.timingMode = .easeInEaseOut
		//target wait for small duration
		let waitAction = SKAction.wait(forDuration: StickMovement.targetTravelTime * 0.2)
		
		//Action block for target removal
		let removeAction = SKAction.run {
			if !self.entityManager.scene.intersects(spriteComponent.node){
				spriteComponent.node.removeAllChildren()
				self.entityManager.remove(entity)
			}
		}
		
		//Action Sequence
		let sequenceAction = SKAction.sequence([waitAction, moveFowardAction, removeAction])
		//run action
		spriteComponent.node.run(SKAction.repeatForever(sequenceAction))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

