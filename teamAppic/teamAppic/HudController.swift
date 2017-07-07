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
class HudController : NSObject, HudProtocol {
    
    /// singleton pattern
    static let hudInstance = HudController()
    
    /// all players in the game. Besides, each player has its score
    public private (set) var playerArray : [Player]
    
    /// timer
    public private (set) var timer = GameTimer()
    
    private override init() {
        self.playerArray = []
    }
    
    /// inserts players in hud (each one will have their score object)
    ///
    /// - Parameter playerNameAndAimArray: array of tuples that contains the name of each player and their aim node in format (name, aimNode)
    public func insertPlayers(playerNameArray : [String], playerAimArray : [SKSpriteNode]) {
        for (playerName,aimNode) in zip(playerNameArray,playerAimArray) {
            let player = Player(playerName: playerName, aimNode : aimNode)
            self.playerArray.append(player)
        }
    }

    /// updates score of the player passed as parameter
    ///
    /// - Parameter player: this value is the number of player decreased by one
    public func updateScore(player: Int) {
        if (player+1 <= playerArray.count) {
            playerArray[player].score.updatesScore()
        } else {
            print ("This player not exists")
        }
    }
}
