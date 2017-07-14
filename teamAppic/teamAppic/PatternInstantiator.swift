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
        
        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.launchTarget), userInfo: nil, repeats: timeDelayArray.count <= 1)
    }
    
    @objc func launchTarget() {
        
        while(true) {

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
            
            if timeDelayArray[launchedCounter % timeDelayArray.count] != 0.0 { break }
        }
        
        if timeDelayArray.count > 0 {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeDelayArray[launchedCounter % timeDelayArray.count], target: self,
                                         selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
        }
    }
}

class DoublePatternCannon {
	var firstBaseLocation : CGPoint!
	var secondBaseLocation : CGPoint!
	var cannonStep : CGPoint!
	var numberOfTargets : Int!
	var targetScale : CGFloat!
	var firstTargetTypeArray : [TargetType] = [TargetType.target]
	var secondTargetTypeArray : [TargetType] = [TargetType.target]
	var baseTargetSpeed : float2!
	var baseTargetAccel : float2!
	var timeDelayArray : [TimeInterval] = [0.0]
	
	var randomizingRange : CGPoint!
	var maxSpeed : Float!
	var maxAccel : Float!
	
	let entityManager : EntityManager
	
	var timer : Timer!
	var launchedCounter : Int = 0
	
	init(firstBaseLocation : CGPoint, secondBaseLocation : CGPoint, cannonStep: CGPoint, numberOfTargets : Int, targetScale : CGFloat, firstTargetTypeArray: [TargetType], secondTargetTypeArray: [TargetType], baseTargetSpeed : float2, baseTargetAccel : float2, timeDelayArray : [TimeInterval], entityManager : EntityManager) {
		
		self.firstBaseLocation = firstBaseLocation
		self.secondBaseLocation = secondBaseLocation

		self.cannonStep = cannonStep
		self.numberOfTargets = numberOfTargets
		self.targetScale = targetScale
		self.firstTargetTypeArray = firstTargetTypeArray
		self.secondTargetTypeArray = secondTargetTypeArray

		self.baseTargetSpeed = baseTargetSpeed
		self.baseTargetAccel = baseTargetAccel
		self.timeDelayArray = timeDelayArray
		self.entityManager = entityManager
		
		timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.launchTarget), userInfo: nil, repeats: timeDelayArray.count <= 1)
	}
	
	@objc func launchTarget() {
		
		while(true) {
			
			if launchedCounter >= numberOfTargets {
				timer.invalidate()
				return
			}
			
			let stick = entityManager.spawnTarget(targetType: firstTargetTypeArray[launchedCounter % firstTargetTypeArray.count],
			                          location: firstBaseLocation,
			                          scale: targetScale,
			                          initialVelocity: baseTargetSpeed,
			                          maxSpeed: maxSpeed,
			                          maxAccel: maxAccel,
			                          moveType: MoveType.gravity,
			                          path: nil,
			                          returnEntity: true)
			
			let duck = entityManager.spawnTarget(targetType: secondTargetTypeArray[launchedCounter % secondTargetTypeArray.count],
			                          location: secondBaseLocation,
			                          scale: targetScale,
			                          initialVelocity: baseTargetSpeed,
			                          maxSpeed: maxSpeed,
			                          maxAccel: maxAccel,
			                          moveType: MoveType.gravity,
			                          path: nil,
			                          returnEntity: true)
			
			stick.relatedEntity = duck
			duck.relatedEntity = stick
			
			self.firstBaseLocation = self.firstBaseLocation + self.cannonStep
			self.secondBaseLocation = self.secondBaseLocation + self.cannonStep
			
			self.launchedCounter += 1
			
			if timeDelayArray[launchedCounter % timeDelayArray.count] != 0.0 { break }
		}
		
		if timeDelayArray.count > 0 {
			timer.invalidate()
			timer = Timer.scheduledTimer(timeInterval: timeDelayArray[launchedCounter % timeDelayArray.count], target: self,
			                             selector: #selector(self.launchTarget), userInfo: nil, repeats: false)
		}
	}
}
