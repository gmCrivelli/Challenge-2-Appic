//
//  Hud.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 05/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

/// class that gerentiates players, timer. In this case, each player contains their score object. Besides, score class contain a static variable to represents the highscore. 
class Hud {
    
    /// singleton pattern
    static let hudInstance = Hud()
    
    /// all players in the game. Besides, each player has its score
    public private (set) var playerArray : [Player]
    
    /// timer
    public private (set) var timer = GameTimer()
    
    private init() {
        self.playerArray = []
    }
    
    /// inserts players in hud (each one will have their score object)
    ///
    /// - Parameter playerNameArray: array that contains the name of each player
    public func insertPlayers(playerNameArray : [String]) {
        for playerName in playerNameArray {
            let player = Player(playerName: playerName)
            playerArray.append(player)
        }
    }
}
