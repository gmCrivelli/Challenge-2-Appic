//
//  Target.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 28/06/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

class Target {
    
    var targetNode: SKNode
    var initialPosition : String
    
    init (node: SKNode, initialPosition : String) {
        self.targetNode = node
        self.initialPosition = initialPosition
    }
}
