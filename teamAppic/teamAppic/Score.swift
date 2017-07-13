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
    
    /// constant that indicates how much is increased in score when updateScore is called
    private let NORMALSCORE = 1
    
    /// current score of a player
    public private (set) var currentScore : Int

    /// indicates how much, besides NORMALSCORE, is added to currentScore
    public private (set) var bonusScore : Int
    
    /// indicates the best high score of all players
    static private var highScore : Int = 0
    
    public init() {
        self.currentScore = 0
        self.bonusScore = 0
        Score.highScore = Score.getHighScore()
    }
    
    
    /// Sets the highscore.
    ///
    /// - Parameter newValue: new value to high score
    private func setHighScore(newValue : Int) {
        UserDefaults.standard.set(newValue, forKey: "HighScore")
    }
    
    
    /// Returns the high score stored by UserDefaults.
    ///
    /// - Returns: high score
    static public func getHighScore() -> Int {
        if let highScore = UserDefaults.standard.integer(forKey: "HighScore") as Int? {
            return highScore
        } else {
            return 0
        }
    }
    
    /// Function that increase the current score of a player.
    public func updatesScore() {
        self.currentScore += (NORMALSCORE + self.bonusScore)
        // updating high score
        if (self.currentScore > Score.highScore) {
            Score.highScore = self.currentScore
            setHighScore(newValue: Score.highScore)
        }
    }
    
    /// Reinitialize all score class parameters.
    public func reInitScore() {
        // restarting currentScore and bonus score 
        self.currentScore = 0
        self.bonusScore = 0
    }
}
