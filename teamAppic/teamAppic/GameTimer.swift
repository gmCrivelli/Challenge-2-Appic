//
//  GameTimer.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 06/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit

/// protocol to present game over view controller
protocol GameOVerProtocol: NSObjectProtocol {
    func loadGameOverScene()
}

class GameTimer {

    /// constant that indicates the gameplay time
    private let GAMEPLAYTIME : Int = 50
    
    /// singleton pattern
    static let gameTimerInstance = GameTimer()
    
    /// gameplay timer
    private var timerCount : Int
	
	/// Timer Label
	private var timerLabelNode : SKLabelNode?
    
    private var timer : Timer?
    
    /// delegate to present game over
    public weak var gameDelegate: GameOVerProtocol?
    
    public init () {
        self.timerCount = GAMEPLAYTIME
        self.timer = Timer()
    }
    
    /// starts the timer counter
    public func startTimer() {
        self.timerCount = GAMEPLAYTIME
        // before setup timer, the timer is invalidated to sure that there is not another scheduled timer
        self.pauseTimer()
        
        self.setupTimer()
    }
    
    /// counts the timer
    @objc private func countsTimer() {
        if (self.timerCount > 0) {
            self.timerCount -= 1
            self.setupTimer()
        } else {
            // game over
            if let gameOverDelegate = gameDelegate {
                gameOverDelegate.loadGameOverScene()
            }
        }
        //Case there is a label to assign the value
        if (timerLabelNode != nil) {
            self.timerLabelNode?.text = "\(getTimer())"
        }
    }
    
    /// setups the scheduled timer
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countsTimer), userInfo: nil, repeats: false)
    }
    
    /// returns the remaining time of timer
    ///
    /// - Returns: remaining time
    public func getTimer() -> Int {
        return self.timerCount
    }
	
	/// set the Timer Label
	///
	/// - Parameter: timerLabel - label for the update
	public func setLabel(timerLabelNode : SKLabelNode){
		self.timerLabelNode = timerLabelNode
	}
    
    /// pauses the timer
    public func pauseTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// resumes the timer
    public func resumeTimer() {
        self.setupTimer()
    }
}
