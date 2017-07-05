//
//  Hud.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 05/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

class Hud {
    private var playerArray : [Player] = []
    
    /// instantiating all players
    ///
    /// - Parameter playerNameArray: array with the name of all players
    public init(playerNameArray : [String]) {
        for playerName in playerNameArray {
            let player = Player(playerName: playerName)
            playerArray.append(player)
        }
    }
}
