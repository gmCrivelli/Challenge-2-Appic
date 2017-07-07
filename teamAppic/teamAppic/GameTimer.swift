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
    private let GAMEPLAYTIME : Int = 61
    
    /// singleton pattern
    static let gameTimerInstance = GameTimer()
    
    /// gameplay timer
    private var timer : Int
	
	/// Timer Label
	private var timerLabelNode : SKLabelNode?
    
    public init () {
        self.timer = GAMEPLAYTIME
    }
    
    /// starts the timer counter
    @objc public func startTimer() {
        if (self.timer > 0) {
            self.timer -= 1
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: false)
        } else {
            print("Game Over")
        }
		//Case there is a label to assign the value
		if (timerLabelNode != nil) {
			self.timerLabelNode?.text = "Time: \(getTimer())"
		}
    }
    
    
    /// returns the remaining time of timer
    ///
    /// - Returns: remaining time
    public func getTimer() -> Int {
        return self.timer
    }
	
	/// set the Timer Label
	///
	/// - Parameter: timerLabel - label for the update
	public func setLabel(timerLabelNode : SKLabelNode){
		self.timerLabelNode = timerLabelNode
	}
}
