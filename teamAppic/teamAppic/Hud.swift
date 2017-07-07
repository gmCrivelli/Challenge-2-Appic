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
	
	/// all score labels Nodes
	private var scoreLabelNodeArray : [SKLabelNode]
	
	/// all player names labels  Node
	private var nameLabelNodeArray : [SKLabelNode]
	
	/// timer label Node
	private var timerLabelNode: SKLabelNode!
    
    /// timer
    public private (set) var timer = GameTimer()
    
    private init() {
        self.playerArray = []
		self.scoreLabelNodeArray = []
		self.nameLabelNodeArray = []
		
		
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
	/// Sets the Hud Scores, Player Names and timer, suports 4 players
	///
	/// - Parameter gameScene: scene that contains the Score, combo, Names labels
	public func setHUD(gameScene: SKScene){
		
		//Get the Node of the timer
		self.timerLabelNode = gameScene.childNode(withName: "timer") as! SKLabelNode
		
		// Get the Nodes for each Player
		var i = 1
		for _ in playerArray {
			
			let playerNameNode = gameScene.childNode(withName: "nameLabel\(i)")
			playerNameNode?.isHidden = false
			self.scoreLabelNodeArray.append(playerNameNode as! SKLabelNode)
			
			let playerScoreNode = gameScene.childNode(withName: "scoreLabel\(i)")
			playerScoreNode?.isHidden = false
			self.nameLabelNodeArray.append(playerScoreNode as! SKLabelNode)
			
			i+=1
		}
	}
	///Update HUD with the current scores and combos
	///
	/// - Parameter
	
}
