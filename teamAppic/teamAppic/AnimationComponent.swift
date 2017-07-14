//
//  AnimationComponent.swift
//  teamAppic
//
//  Created by Richard Vaz da Silva Netto on 14/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum AnimationType : Int {
	case duck = 1
	case duckStick = 2
	case target = 3
}



class AnimationComponent : GKComponent {
	
	var entityManager : EntityManager
	var animationType : AnimationType = .target
	var animationTime : TimeInterval
	var animationExecuted : Bool = false
	var animationDistance : Double!
	var imageName : String
	
	init(entityManager: EntityManager, animationTime: TimeInterval, name: String) {
		
		self.entityManager = entityManager
		self.animationTime = animationTime
		self.imageName = name
		super.init()
		//Deve ser mudado caso as imagens mudem
		switch name {
		case "duck":
			self.animationType = .duck
		case "duckStick":
			self.animationType = .duckStick
		default:
			self.animationType = .target
			break
		}
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		super.update(deltaTime: seconds)
		
		switch animationType {
		case .duck:
			guard let entity = entity,
				let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
					return
			}
			//Only runs 1 time
			if !animationExecuted {
				//Action to resize the node in y within some time
				let distDown = -spriteComponent.node.frame.width
				let moveAction = SKAction.moveBy(x: 0, y: distDown, duration: animationTime)
				let resizeAction = SKAction.scaleY(to: CGFloat(0), duration: animationTime)
				spriteComponent.node.run(moveAction)
				spriteComponent.node.run(resizeAction)
				animationExecuted = true
			}
			
			if spriteComponent.node.frame.height < 0.1 {
				entityManager.remove(entity)
			}
			
		case .duckStick:
			guard let entity = entity,
				let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
					return
			}
			//Only runs 1 time
			if !animationExecuted {
				//Action to resize the node in y within some time
				let distDown = -spriteComponent.node.frame.width*4
				let moveAction = SKAction.moveBy(x: 0, y: distDown, duration: animationTime)
				let resizeAction = SKAction.scaleY(to: CGFloat(0), duration: animationTime)
				spriteComponent.node.run(moveAction)
				spriteComponent.node.run(resizeAction)
				animationExecuted = true
			}
			
			if spriteComponent.node.frame.height < 0.1 {
				entityManager.remove(entity)
			}
			
		default:
			break
		}
	}
	
}
