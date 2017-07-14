//
//  Target.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Target: GKEntity {
	var name: String!
    weak var entityManager : EntityManager!
	var relatedEntity: GKEntity?
    
    init(targetType: TargetType, moveType: MoveType, maxSpeed: Float, maxAccel: Float?, entityManager: EntityManager) {
        super.init()
        let texture = SKTexture(imageNamed: targetType.getImageName())
		//Solution for the tipe of node, gets the image name as identifier for the Sprite type
		//MUST be replaced
		self.name = targetType.getImageName()
        let spriteComponent = SpriteComponent(imageNamed: targetType.getImageName())
        
        addComponent(spriteComponent)
        addComponent(TypeComponent(targetType: targetType))
        
        switch targetType {
        
        case .target:
            addComponent(MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAccel, radius: Float(texture.size().width * 0.3), moveType: moveType, entityManager: entityManager))
        default:
            addComponent(DuckMovement(duckSpeed: maxSpeed, entityManager: entityManager))
            self.component(ofType: DuckMovement.self)?.run()
        }
    }
    
    func setPath(path: GKPath) {
        if let moveComponent = self.component(ofType: MoveComponent.self) {
            moveComponent.setPath(path: path)
        }
    }
    
    func setInitialVelocity(velocity: float2) {
        if let moveComponent = self.component(ofType: MoveComponent.self) {
            moveComponent.setSpeedVector(speedVector: velocity)
        }
    }
    
    func setInitialAccel(accel: float2) {
        if let moveComponent = self.component(ofType: MoveComponent.self) {
            moveComponent.setAccelVector(accelVector: accel)
        }
    }
	
	func addRelated(related: GKEntity){
		self.relatedEntity = related
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
