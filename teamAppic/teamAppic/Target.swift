//
//  Target.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

class Target {
    
    
    var node : SKNode!
    var initialPosition : CGPoint!
    var xMovementModule : TargetMovementModule = LinearMovementModule.getInstance()
    var yMovementModule : TargetMovementModule = ElasticMovementModule.getInstance()
    
    init (node: SKNode, initialPosition : CGPoint) {
        self.node = node
        self.initialPosition = initialPosition
        self.node.run(SKAction.group([xMovementModule.getXMovementAction(distance: 300, duration: 1),
                        yMovementModule.getYMovementAction(distance: 100, duration: 1)]))
    }
}
