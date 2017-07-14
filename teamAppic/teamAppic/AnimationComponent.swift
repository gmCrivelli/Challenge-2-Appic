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
	case resizeDown = 1
	case moveDown = 2
}

class AnimationComponent : GKComponent {
	
	var entityManager : EntityManager
	var animationType : AnimationType
	var animationTime : TimeInterval
	var animationExecuted : Bool = false
	var animationDistance : Double!
	
	init(entityManager: EntityManager, animationTime: TimeInterval, animationType: AnimationType) {
		
		self.entityManager = entityManager
		self.animationTime = animationTime
		self.animationType = animationType
		super.init()
		
		if animationType == .resizeDown {
			self.animationType = .resizeDown
		}
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		super.update(deltaTime: seconds)
		
		switch animationType {
		case .resizeDown:
			guard let entity = entity,
				let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
					return
			}
			//Only runs 1 time
			if !animationExecuted {
				//Action to resize the node in y within some time
				let distDown = -spriteComponent.node.frame.width/2
				let moveAction = SKAction.moveBy(x: 0, y: distDown, duration: animationTime)
				let resizeAction = SKAction.scaleY(to: CGFloat(0), duration: animationTime)
				spriteComponent.node.run(moveAction)
				spriteComponent.node.run(resizeAction)
				animationExecuted = true
			}
			
			if spriteComponent.node.frame.height < 0.1 {
				entityManager.remove(entity)
			}
			
		default: break
		}
	}
	
}
