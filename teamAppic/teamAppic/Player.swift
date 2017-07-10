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
    
    /// each player has their score (one object of class score)
    public let score = Score()
    
    /// name of this player
    public private (set) var playerName : String
    
    /// aim node of the player
    public private (set) var aimNode : SKSpriteNode!
    
	public init (playerName : String, aimNode : SKSpriteNode) {
        self.playerName = playerName
        self.aimNode = aimNode
    }
}
