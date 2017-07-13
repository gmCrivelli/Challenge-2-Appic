//
//  TypeComponent.swift
//  choraGabe
//
//  Created by Gustavo De Mello Crivelli on 06/07/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum TargetType : Int{
    case type1 = 1
    case type2 = 2
    
    static let allValues = [type1, type2]
    
    func toFollow() -> TargetType {
        switch self {
        default: return .type2
        }
    }
    
    func getImageName() -> String {
        return "target"
    }
    
    func getBZPathForType() -> UIBezierPath {
        switch self {
            default:
                let path = UIBezierPath()
                path.addArc(withCenter: CGPoint(x: 89, y: 85), radius: 85, startAngle: 0, endAngle: 360, clockwise: true)
                return path
        }
    }
    
    func getCGPathForType() -> CGPath {
        switch self {
        default:
            let path = CGPath(rect: SKTexture(imageNamed: "target").textureRect() , transform: nil)
            //path.addArc(withCenter: CGPoint(x: 89, y: 85), radius: 85, startAngle: 0, endAngle: 360, clockwise: true)
            return path
        }
    }
}

class TypeComponent : GKComponent {
    let targetType : TargetType
    
    init(targetType: TargetType) {
        self.targetType = targetType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
