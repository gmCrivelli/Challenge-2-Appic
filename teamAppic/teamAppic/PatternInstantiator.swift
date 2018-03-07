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
    var targetTypeArray : [TargetType] = [TargetType.target]
    var baseTargetSpeed : float2!
    var baseTargetAccel : float2!
    var timeDelayArray : [TimeInterval] = [0.0]
    
    var randomizingRange : CGPoint!
    var maxSpeed : Float = 300
    var maxAccel : Float = 100
    
    let entityManager : EntityManager
    
    var timer : Timer!
    var launchedCounter : Int = 0
    
    var sequence : [SKAction]!
    
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
        
        //        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
        //        self.launchTarget()
        // instantiating the number of ducks and sticks
        
        var i = 0
        sequence = []
        while i < numberOfTargets {
            
            sequence.append(SKAction.run {
                self.launchTarget() } )
            
            if self.timeDelayArray[self.launchedCounter % self.timeDelayArray.count] > 0 {
                sequence.append(SKAction.wait(forDuration: (self.timeDelayArray[self.launchedCounter % self.timeDelayArray.count])))
                
                i += 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func launchTarget() {
        
        //        while(true) {
        //            if launchedCounter >= numberOfTargets {
        //                timer.invalidate()
        //                return
        //            }
        
        let t1 = entityManager.spawnTarget(targetType: targetTypeArray[launchedCounter % targetTypeArray.count],
                                  location: baseLocation,
                                  scale: targetScale,
                                  initialVelocity: baseTargetSpeed,
                                  initialAccel: baseTargetAccel,
                                  maxSpeed: baseTargetSpeed.x,
                                  maxAccel: maxAccel,
                                  moveType: MoveType.gravity,
                                  path: nil,
                                  returnEntity: true)
        
        if targetTypeArray[launchedCounter % targetTypeArray.count] == .stickLeft {
            let t2 = entityManager.spawnTarget(targetType: .duckLeft,
                                      location: CGPoint(x: baseLocation.x, y: baseLocation.y + 100),
                                      scale: targetScale,
                                      initialVelocity: baseTargetSpeed,
                                      initialAccel: baseTargetAccel,
                                      maxSpeed: baseTargetSpeed.x,
                                      maxAccel: maxAccel,
                                      moveType: MoveType.gravity,
                                      path: nil,
                                      returnEntity: true)
            
            t1.relatedEntity = t2
            t2.relatedEntity = t1
        }
        
        if targetTypeArray[launchedCounter % targetTypeArray.count] == .stickRight {
            let t2 = entityManager.spawnTarget(targetType: .duckRight,
                                               location: CGPoint(x: baseLocation.x, y: baseLocation.y + 100),
                                               scale: targetScale,
                                               initialVelocity: baseTargetSpeed,
                                               initialAccel: baseTargetAccel,
                                               maxSpeed: maxSpeed,
                                               maxAccel: maxAccel,
                                               moveType: MoveType.gravity,
                                               path: nil,
                                               returnEntity: true)
            
            t1.relatedEntity = t2
            t2.relatedEntity = t1
        }
        
        self.baseLocation = self.baseLocation + self.cannonStep
        self.launchedCounter += 1
        
        //            if timeDelayArray[launchedCounter % timeDelayArray.count] != 0.0 { break }
        //        }
        
        //        if timeDelayArray.count > 0 {
        //            timer.invalidate()
        ////            timer = Timer.scheduledTimer(timeInterval: timeDelayArray[launchedCounter % timeDelayArray.count], target: self,
        ////                                         selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
        //        }
    }
}

class PatternInstantiator {
    
    let entityManager : EntityManager
    var patternArray = [(TimeInterval, PatternCannon)]()
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        setupArray()
    }
    
    func setupArray() {
        
//        // Duck patterns
//        patternArray.append((0.0,
//                             PatternCannon(baseLocation: CGPoint(x: 960, y: -350),
//                                          cannonStep: CGPoint(x: 0, y: 0),
//                                          numberOfTargets: 10,
//                                          targetScale: 0.9,
//                                          targetTypeArray: [TargetType.stickLeft],
//                                          baseTargetSpeed: float2(x: -400, y: 0),
//                                          baseTargetAccel: float2(x: 0, y: 0),
//                                          timeDelayArray: [DuckMovement.targetTravelTime * 1.2],
//                                          entityManager: entityManager)))
//        
//        //Cross Targets
//        //1o.
//        patternArray.append((0.0,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 500, y: 700),
//                                           baseTargetAccel: float2(x: 0, y: -350),
//                                           timeDelayArray: [2],
//                                           entityManager: entityManager)))
//        
//        //2o.
//        patternArray.append((1.0,
//                             PatternCannon(baseLocation: CGPoint(x: 960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: -500, y: 700),
//                                           baseTargetAccel: float2(x: 0, y: -350),
//                                           timeDelayArray: [2],
//                                           entityManager: entityManager)))
//        
//        patternArray.append((10.0,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -500),
//                                           cannonStep: CGPoint(x: 150, y: 0),
//                                           numberOfTargets: 15,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 0, y: 600),
//                                           baseTargetAccel: float2(x: 0, y: -250),
//                                           timeDelayArray: [0.3],
//                                           entityManager: entityManager)))
//        
//        
//        // Move to other side of screen
//        patternArray.append((6.0,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -50),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 6,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 500, y: 0),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1.5],
//                                           entityManager: entityManager)))
//        
//        //2o.
//        patternArray.append((1.0,
//                             PatternCannon(baseLocation: CGPoint(x: 960, y: 300),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 6,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: -500, y: 0),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1.5],
//                                           entityManager: entityManager)))
//        
//        //3o.
//        patternArray.append((1.0,
//                             PatternCannon(baseLocation: CGPoint(x: -400, y: -540),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 6,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 0, y: 500),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1.5],
//                                           entityManager: entityManager)))
//        
//        //4o.
//        patternArray.append((1.0,
//                             PatternCannon(baseLocation: CGPoint(x: 400, y: 540),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 6,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 0, y: -500),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1.5],
//                                           entityManager: entityManager)))
//
//        //Up Above
//        //Left
//        patternArray.append((9.0,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 350, y: 0),
//                                           baseTargetAccel: float2(x: 0, y: 350),
//                                           timeDelayArray: [2],
//                                           entityManager: entityManager)))
//        
//        //Right
//        patternArray.append((1.0,
//                             PatternCannon(baseLocation: CGPoint(x: 960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: -350, y: 0),
//                                           baseTargetAccel: float2(x: 0, y: 350),
//                                           timeDelayArray: [2],
//                                           entityManager: entityManager)))
//        
//        patternArray.append((0.0,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -400),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 10,
//                                           targetScale: 0.9,
//                                           targetTypeArray: [TargetType.stickRight],
//                                           baseTargetSpeed: float2(x: 500, y: 0),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [DuckMovement.targetTravelTime * 1.2],
//                                           entityManager: entityManager)))
//        
//        // Flower left
//        patternArray.append((12.0,
//                             PatternCannon(baseLocation: CGPoint(x: 0, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.5,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: -500, y: 700),
//                                           baseTargetAccel: float2(x: 0, y: -250),
//                                           timeDelayArray: [0.6],
//                                           entityManager: entityManager)))
//        
//        // center
//        patternArray.append((0.0,
//                             PatternCannon(baseLocation: CGPoint(x: 0, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 0, y: 500),
//                                           baseTargetAccel: float2(x: 0, y: -250),
//                                           timeDelayArray: [0.6],
//                                           entityManager: entityManager)))
//        // right
//        patternArray.append((0.0,
//                             PatternCannon(baseLocation: CGPoint(x: 0, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.5,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 500, y: 700),
//                                           baseTargetAccel: float2(x: 0, y: -250),
//                                           timeDelayArray: [0.6],
//                                           entityManager: entityManager)))
//        
//        //Up Above
//        //Left
//        patternArray.append((4.3,
//                             PatternCannon(baseLocation: CGPoint(x: -960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: 350, y: 350),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1],
//                                           entityManager: entityManager)))
//        
//        //Right
//        patternArray.append((0.5,
//                             PatternCannon(baseLocation: CGPoint(x: 960, y: -500),
//                                           cannonStep: CGPoint(x: 0, y: 0),
//                                           numberOfTargets: 5,
//                                           targetScale: 0.7,
//                                           targetTypeArray: [TargetType.target],
//                                           baseTargetSpeed: float2(x: -350, y: 350),
//                                           baseTargetAccel: float2(x: 0, y: 0),
//                                           timeDelayArray: [1],
//                                           entityManager: entityManager)))

        // MEGA TARGET
        patternArray.append((6.5,
                             PatternCannon(baseLocation: CGPoint(x: 0, y: -700),
                                           cannonStep: CGPoint(x: 0, y: 0),
                                           numberOfTargets: 1,
                                           targetScale: 3.7,
                                           targetTypeArray: [TargetType.target],
                                           baseTargetSpeed: float2(x: 0, y: 350),
                                           baseTargetAccel: float2(x: 0, y: -75),
                                           timeDelayArray: [0.6],
                                           entityManager: entityManager)))
        
        
        
    }
    
}








