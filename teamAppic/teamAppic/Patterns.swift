//
//  Patterns.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

/* Tuple:
        imageName : String
        targetType : TargetType
        location : CGPoint
            x : CGFloat (in percentage of screen width)
            y : CGFloat (in percentage of screen width)
        scale : CGFloat (in percentage of texture size)
        moveType : MoveType
        initialVelocity: float2 (for use with gravity)
        maxSpeed : Float
        maxAccel : Float
        path : GKPath (may be nil for static targets)
        radius : Float
        cyclical : Bool
        timeToNext : Double (time to next target instantiation)
*/


// List of patterns
// Each pattern is a list of tuples
// Each tuple contains the above elements
let patterns = [[(imageName: "Spaceship",
                   targetType: TargetType.target,
                   location: CGPoint(x: -0.1, y: -0.1),
                   scale: CGFloat(0.3),
                   moveType: MoveType.path,
                   initialVelocity: float2(x: 0, y: 500),
                   maxSpeed : Float(400),
                   maxAccel : Float(10),
                   pathPoints: [float2(x: 0, y: 0),
                                float2(x: 1, y: 1)],
                   pathRadius: Float(0.1),
                   cyclical: false,
                   timeToNext: 0.0),
                 ],
                
                
                [(imageName: "Spaceship",
                  targetType: TargetType.target,
                  location: CGPoint(x: 0.1, y: -0.1),
                  scale: CGFloat(0.3),
                  moveType: MoveType.gravity,
                  initialVelocity: float2(x: 0, y: 500),
                  maxSpeed : Float(800),
                  maxAccel : Float(10),
                  pathPoints: [float2(x: 0.1, y: -0.1),
                               float2(x: 0.1, y: 0.3)],
                               //float2(x: 0.1, y: -0.1)],
                  pathRadius: Float(0.1),
                  cyclical: true,
                  timeToNext: 0.5),
                 
                 (imageName: "Spaceship",
                  targetType: TargetType.target,
                  location: CGPoint(x: 0.3, y: -0.1),
                  scale: CGFloat(0.3),
                  moveType: MoveType.gravity,
                  initialVelocity: float2(x: 0, y: 500),
                  maxSpeed : Float(800),
                  maxAccel : Float(10),
                  pathPoints: [float2(x: 0.3, y: -0.1),
                               float2(x: 0.3, y: 0.55)],
                               //float2(x: 0.3, y: -0.1)],
                  pathRadius: Float(0.1),
                  cyclical: true,
                  timeToNext: 0.5),
                 
                 (imageName: "Spaceship",
                  targetType: TargetType.target,
                  location: CGPoint(x: 0.5, y: -0.1),
                  scale: CGFloat(0.3),
                  moveType: MoveType.gravity,
                  initialVelocity: float2(x: 0, y: 500),
                  maxSpeed : Float(800),
                  maxAccel : Float(10),
                  pathPoints: [float2(x: 0.5, y: -0.1),
                               float2(x: 0.5, y: 0.8)],
                               //float2(x: 0.5, y: -0.1),],
                  pathRadius: Float(0.1),
                  cyclical: true,
                  timeToNext: 0.5)]
                ]/*
                 [],
                 [],
                 [],
                 [],
                 [],
                 [],
                 ],
                [[]],
                [[]],
                [[]]]*/
