////
////  MoveComponent.swift
////  choraGabe
////
////  Created by Gustavo De Mello Crivelli on 06/07/17.
////  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//import GameplayKit
//
//enum MoveType : Int {
//    case followAgent = 1
//    case gravity = 2
//    case path = 3
//}
//
//class AgentMoveComponent: GKAgent2D, GKAgentDelegate {
//    
//    let entityManager : EntityManager
//    var moveType : MoveType
//    var path : GKPath!
//    var speedVector = float2(x: 0, y: 0)
//    var accelVector = float2(x: 0, y: -100)
//    var newPosition = float2(x: 0, y: 0)
//    
//    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, moveType: MoveType, entityManager: EntityManager) {
//        
//        self.entityManager = entityManager
//        self.moveType = moveType
//        super.init()
//        delegate = self
//        self.maxSpeed = maxSpeed
//        self.maxAcceleration = maxAcceleration
//        self.radius = radius
//        self.mass = 0.01
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setPath(path: GKPath) {
//        self.path = path
//    }
//    
//    func setSpeedVector(speedVector: float2) {
//        self.speedVector = speedVector
//    }
//    
//    func setAccelVector(accelVector: float2) {
//        self.accelVector = accelVector
//    }
//    
//    func agentWillUpdate(_ agent: GKAgent) {
//        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
//            return
//        }
//        position = float2(spriteComponent.node.position)
//    }
//    
//    func agentDidUpdate(_ agent: GKAgent) {
//        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
//            return
//        }
//        spriteComponent.node.position = CGPoint(position)
//    }
//    
//    func closestMoveComponent(for targetType: TargetType) -> GKAgent2D? {
//    
//        var closestMoveComponent: MoveComponent? = nil
//        var closestDistance = CGFloat(0)
//        
//        let goalMoveComponents = entityManager.getMoveComponents(for: targetType)
//        for goalMoveComponent in goalMoveComponents {
//            let distance = (CGPoint(goalMoveComponent.position) - CGPoint(position)).length()
//            if closestMoveComponent == nil || distance < closestDistance {
//                closestDistance = distance
//                closestMoveComponent = goalMoveComponent
//            }
//        }
//        return closestMoveComponent
//    }
//    
//    override func update(deltaTime seconds: TimeInterval) {
//        
//        super.update(deltaTime: seconds)
//    
//        switch moveType {
//        case .followAgent:
//            guard let entity = entity,
//                let typeComponent = entity.component(ofType: TypeComponent.self) else {
//                    return
//            }
//            
//            guard let goalMoveComponent = closestMoveComponent(for: typeComponent.targetType.toFollow()) else {
//                return
//            }
//            
//            behavior = FollowBehavior(targetSpeed: maxSpeed, seek: goalMoveComponent, avoid: [])
//
//        case .path:
//            guard let entity = entity,
//                let typeComponent = entity.component(ofType: TypeComponent.self) else {
//                    return
//            }
//            
//            guard let movePath = path else { return }
//            
//            behavior = PathBehavior(targetSpeed: maxSpeed, path: movePath, forward: true, avoid: [])
//            
//        case .gravity:
//            let fseconds = Float(seconds)
//            self.newPosition = float2(x: self.position.x + speedVector.x * fseconds,
//                                   y: self.position.y + speedVector.y * fseconds)
//            speedVector = float2(x: speedVector.x + accelVector.x * fseconds,
//                                 y: speedVector.y + accelVector.y * fseconds)
//            
//        default: break
//        }
//        
//        
//    }
//    
//}
