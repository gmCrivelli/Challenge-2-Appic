//
//  GameTimer.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 06/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimer {

    /// constant that indicates the gameplay time
    private let GAMEPLAYTIME : Int = 60
    
    /// singleton pattern
    static let gameTimerInstance = GameTimer()
    
    /// gameplay timer
    private var timer : Int
    
    public init () {
        self.timer = GAMEPLAYTIME
    }
    
    /// starts the timer counter
    @objc public func startTimer() {
        print(self.timer)
        if (self.timer > 0) {
            self.timer -= 1
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: false)
        } else {
            print("Game Over")
        }
    }
    
    
    /// returns the remaining time of timer
    ///
    /// - Returns: remaining time
    public func getTimer() -> Int {
        return self.timer
    }
}
