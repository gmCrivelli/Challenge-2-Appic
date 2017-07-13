//
//  PatternInstantiator.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PatternCannon {
    var baseLocation : CGPoint!
    var cannonStep : CGPoint!
    var numberOfTargets : Int!
    var targetScale : CGFloat!
    var targetTypeArray : [TargetType] = [TargetType.type1]
    var baseTargetSpeed : float2!
    var baseTargetAccel : float2!
    var timeDelayArray : [TimeInterval] = [0.0]
    
    var randomizingRange : CGPoint!
    var maxSpeed : Float!
    var maxAccel : Float!
    
    let entityManager : EntityManager
    
    var timer : Timer!
    var launchedCounter : Int = 0
    
    init(baseLocation : CGPoint, cannonStep: CGPoint, numberOfTargets : Int, targetScale : CGFloat, targetTypeArray: [TargetType], baseTargetSpeed : float2, baseTargetAccel : float2, timeDelayArray : [TimeInterval], entityManager : EntityManager) {
        
        self.baseLocation = baseLocation
        self.cannonStep = cannonStep
        self.numberOfTargets = numberOfTargets
        self.targetScale = targetScale
        self.targetTypeArray = targetTypeArray
        self.baseTargetSpeed = baseTargetSpeed
        self.baseTargetAccel = baseTargetAccel
        self.timeDelayArray = timeDelayArray
        self.entityManager = entityManager
        
        timer = Timer.scheduledTimer(timeInterval: timeDelayArray[0], target: self, selector: #selector(self.launchTarget), userInfo: nil, repeats: timeDelayArray.count <= 1)
    }
    
    @objc func launchTarget() {
        
        if launchedCounter >= numberOfTargets {
            timer.invalidate()
            return
        }
        
        entityManager.spawnTarget(targetType: targetTypeArray[launchedCounter % targetTypeArray.count],
                                  location: baseLocation,
                                  scale: targetScale,
                                  initialVelocity: baseTargetSpeed,
                                  maxSpeed: maxSpeed,
                                  maxAccel: maxAccel,
                                  moveType: MoveType.gravity,
                                  path: nil)
        
        self.baseLocation = self.baseLocation + self.cannonStep
        self.launchedCounter += 1
        
        if timeDelayArray.count > 1 {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeDelayArray[launchedCounter % timeDelayArray.count], target: self,
                                         selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
        }
    }
}

class DuckCannon {
    var baseLocation : CGPoint!
    var cannonStep : CGPoint!
    var numberOfTargets : Int!
    var targetScale : CGFloat!
    var targetTypeArray : [TargetType] = [TargetType.type1]
    var baseTargetSpeed : float2!
    var baseTargetAccel : float2!
    var timeDelayArray : [TimeInterval] = [0.0]
    
    var randomizingRange : CGPoint!
    var maxSpeed : Float!
    var maxAccel : Float!
    
    let entityManager : EntityManager
    
    var timer : Timer!
    var launchedCounter : Int = 0
    
    init(baseLocation : CGPoint, cannonStep: CGPoint, numberOfTargets : Int, targetScale : CGFloat, targetTypeArray: [TargetType], baseTargetSpeed : float2, baseTargetAccel : float2, timeDelayArray : [TimeInterval], entityManager : EntityManager) {
        
        self.baseLocation = baseLocation
        self.cannonStep = cannonStep
        self.numberOfTargets = numberOfTargets
        self.targetScale = targetScale
        self.targetTypeArray = targetTypeArray
        self.baseTargetSpeed = baseTargetSpeed
        self.baseTargetAccel = baseTargetAccel
        self.timeDelayArray = timeDelayArray
        self.entityManager = entityManager
        
        timer = Timer.scheduledTimer(timeInterval: timeDelayArray[0], target: self, selector: #selector(self.launchTarget), userInfo: nil, repeats: timeDelayArray.count <= 1)
    }
    
    @objc func launchTarget() {
        
        if launchedCounter >= numberOfTargets {
            timer.invalidate()
            return
        }
        
        entityManager.spawnTarget(targetType: targetTypeArray[launchedCounter % targetTypeArray.count],
                                  location: baseLocation,
                                  scale: targetScale,
                                  initialVelocity: baseTargetSpeed,
                                  maxSpeed: maxSpeed,
                                  maxAccel: maxAccel,
                                  moveType: MoveType.noGravity,
                                  path: nil)
        
        self.baseLocation = self.baseLocation + self.cannonStep
        self.launchedCounter += 1
        
        if timeDelayArray.count > 1 {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeDelayArray[launchedCounter % timeDelayArray.count], target: self,
                                         selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
        }
    }
}