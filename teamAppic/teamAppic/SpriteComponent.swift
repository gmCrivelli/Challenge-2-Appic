//
//  SpriteComponent.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, path: UIBezierPath) {
        self.node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        //let hitbox = SKShapeNode(circleOfRadius: texture.size().width - 12)
        //rself.node.addChild(hitbox)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
