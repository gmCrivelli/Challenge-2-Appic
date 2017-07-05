//
//  MovementModules.swift
//  teamAppic
//
//  Created by Gustavo De Mello Crivelli on 04/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

/// Singleton class with functions to return movement actions.
/// These will be executed during target updates
protocol TargetMovementModule {
    
    static func getInstance() -> TargetMovementModule
    func getXMovementAction(distance: CGFloat, duration: Double) -> SKAction
    func getYMovementAction(distance: CGFloat, duration: Double) -> SKAction
}

class LinearMovementModule : TargetMovementModule {
    
    static let sharedInstance = LinearMovementModule()
    private init() {} // This prevents others from using the default init
    
    static func getInstance() -> TargetMovementModule {
        return LinearMovementModule.sharedInstance
    }
    
    func getXMovementAction(distance: CGFloat, duration: Double) -> SKAction {
        let action = SKAction.moveBy(x: distance, y: 0.0, duration: duration)
        return SKAction.repeatForever(action)
    }
    
    func getYMovementAction(distance: CGFloat, duration: Double) -> SKAction {
        let action = SKAction.moveBy(x: 0.0, y: distance, duration: duration)
        return SKAction.repeatForever(action)
    }
    
}

class ElasticMovementModule : TargetMovementModule {
    
    static let sharedInstance = ElasticMovementModule()
    private init() {} // This prevents others from using the default init
    
    static func getInstance() -> TargetMovementModule {
        return ElasticMovementModule.sharedInstance
    }

    func getXMovementAction(distance: CGFloat, duration: Double) -> SKAction {
        let action = SKAction.moveBy(x: distance, y: 0.0, duration: duration)
        action.timingMode = .easeOut
        let sequence = SKAction.sequence([action, action.reversed()])
        return sequence
    }
    
    func getYMovementAction(distance: CGFloat, duration: Double) -> SKAction {
        let action = SKAction.moveBy(x: 0.0, y: distance, duration: duration)
        action.timingMode = .easeOut
        let sequence = SKAction.sequence([action, action.reversed()])
        return sequence
    }
    
}

//class SinusoidalMovementModule : TargetMovementModule {
//    
//    static let sharedInstance = SinusoidalMovementModule()
//    private init() {} // This prevents others from using the default init
//    
//    static func getInstance() -> TargetMovementModule {
//        return SinusoidalMovementModule.sharedInstance
//    }
//    
//    func getYMovementAction(distance: CGFloat, duration: Double) -> SKAction {
//        let action = SKAction.customAction(withDuration: duration / 2, actionBlock: { node, currentTime in
//            
//        })
//    }
//    
//    func getXMovementAction(distance: CGFloat, duration: Double) -> SKAction {
//        let action = SKAction.moveBy(x: distance, y: 0.0, duration: duration)
//        action.timingMode = .easeOut
//        let sequence = SKAction.sequence([action, action.reversed()])
//        return sequence
//    }
//    
//}
