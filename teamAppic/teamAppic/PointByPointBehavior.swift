//
//  PointByPointBehavior.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PointByPointBehavior : GKBehavior {
    
    init(targetSpeed: Float, path: GKPath, forward: Bool, avoid: [GKAgent]) {
        super.init()
        
        if targetSpeed > 0 {
            setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
            
            setWeight(0.5, for: GKGoal(toFollow: path, maxPredictionTime: 1.1, forward: forward))
        }
    }
    
}
