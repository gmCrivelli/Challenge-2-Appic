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
        return "target-2"
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
