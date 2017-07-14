//
//  Player.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 05/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

class PlayersColors {
    private static let colorPlayer : [UIColor] = [.green, .yellow, .red, .purple]
    private static let numberOfPlayers = 4
    
    
    /// returns the color of player
    ///
    /// - Parameter player: player which color is required
    /// - Returns: color that refers to this player
    static func playerColor(player : Int) -> UIColor {
        return colorPlayer[player]
    }
    
    
    
}
