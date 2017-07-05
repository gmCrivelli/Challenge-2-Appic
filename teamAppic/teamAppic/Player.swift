//
//  Player.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 05/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    private let score = Score()
    
    public private (set) var playerName : String
    
    public init (playerName : String) {
        self.playerName = playerName
    }
}
