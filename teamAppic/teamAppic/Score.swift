//
//  Score.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 05/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

class Score {
    
    private let NORMALSCORE = 1
    
    public private (set) var currentScore : Int

    public private (set) var bonusScore : Int
    
    static public private (set) var highScore : Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "HighScore")
            Score.highScore = newValue
        }
        get {
            return (UserDefaults.standard.integer(forKey: "HighScore"))
        }
    }
    
    public init() {
        self.currentScore = 0
        self.bonusScore = 0
        Score.highScore = 0
    }
    
    
    /// function that increase the current score of a player
    public func updatesScore() {
        self.currentScore += (NORMALSCORE + self.bonusScore)
    }
    
    /// this function is called when the game was ended, to check player score and update highscore if necessary
    public func updateHighScore() {
        // updating high score
        if (self.currentScore > Score.highScore) {
            Score.highScore = self.currentScore
        }
    }
}
