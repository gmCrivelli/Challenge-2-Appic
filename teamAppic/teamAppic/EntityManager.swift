//
//  EntityManager.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [moveSystem]
    }()
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    func spawnTarget(targetType: TargetType, location: CGPoint, scale: CGFloat, initialVelocity: float2, maxSpeed: Float?, maxAccel: Float?, moveType: MoveType, path: GKPath?) {
        
        let target = Target(targetType: targetType, moveType: moveType, maxSpeed: maxSpeed, maxAccel: maxAccel, entityManager: self)
        
        if let movePath = path {
            target.setPath(path: movePath)
        }
        
        target.setInitialVelocity(velocity: initialVelocity)
        
        if let spriteComponent = target.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = location
            spriteComponent.node.zPosition = 1000
            spriteComponent.node.setScale(scale)
        }
        add(target)
    }

    
    func getEntities(for targetType: TargetType?) -> [GKEntity] {
        if let type = targetType {
            return entities.flatMap{ entity in
                if let typeComponent = entity.component(ofType: TypeComponent.self) {
                    if typeComponent.targetType == type {
                        return entity
                    }
                }
                return nil
            }
        }
        else {
            return Array(entities)
        }
    }
    
    func getMoveComponents(for targetType: TargetType?) -> [MoveComponent] {
        let entitiesToMove = getEntities(for: targetType)
        var moveComponents = [MoveComponent]()
        for entity in entitiesToMove {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }
    
}
