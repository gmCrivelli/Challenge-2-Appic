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
    case target = 1
    case duckLeft = 2
    case duckRight = 3
	case stickLeft = 4
    case stickRight = 5
    
    static let allValues = [target, duckLeft, duckRight, stickLeft, stickRight]
    
    func getImageName() -> String {
        switch self {
        case .duckLeft:
            return "duckLeft"
        case .duckRight:
            return "duckRight"
        case .stickRight:
            fallthrough
		case .stickLeft:
			return "duckStick"
        default: return "target"
        }
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
