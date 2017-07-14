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
    
    weak var entityManager : EntityManager!
    
    init(targetType: TargetType, moveType: MoveType, maxSpeed: Float?, maxAccel: Float?, entityManager: EntityManager) {
        super.init()
        let texture = SKTexture(imageNamed: targetType.getImageName())
        let spriteComponent = SpriteComponent(imageNamed: targetType.getImageName())
        addComponent(spriteComponent)
        addComponent(TypeComponent(targetType: targetType))
        
        switch targetType {
            
        case .duck:
            addComponent(DuckMovement(entityManager: entityManager))
            self.component(ofType: DuckMovement.self)?.run()
		case .stick:
			addComponent(StickMovement(entityManager: entityManager))
			self.component(ofType: StickMovement.self)?.run()
        default:
            addComponent(MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAccel, radius: Float(texture.size().width * 0.3), moveType: moveType, entityManager: entityManager))
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
