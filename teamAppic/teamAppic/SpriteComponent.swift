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
    
    let node: SKShapeNode
    let size: CGRect
    
//    init(texture: SKTexture) {
//        self.node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
//        //let hitbox = SKShapeNode(circleOfRadius: texture.size().width - 12)
//        //rself.node.addChild(hitbox)
//        super.init()
//    }

    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: imageNamed)
        var shapeNode: SKShapeNode
        if imageNamed == "target" {
            shapeNode = SKShapeNode(circleOfRadius: texture.size().width/2)
        } else {
            shapeNode = SKShapeNode(rectOf: texture.size())
        }
        shapeNode.fillTexture = texture
        shapeNode.fillColor = SKColor.white
        shapeNode.strokeColor = .clear
        self.node = shapeNode
        
        let width = texture.size().width
        let height = texture.size().height
        
        self.size = CGRect(x: -width/2, y: -height/2, width: width, height: height)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
