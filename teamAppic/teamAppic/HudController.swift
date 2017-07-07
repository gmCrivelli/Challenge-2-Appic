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
	
	/// all score labels Nodes
	private var scoreLabelNodeArray : [SKLabelNode]

	/// all player names labels  Node
	private var nameLabelNodeArray : [SKLabelNode]

	/// timer label Node
	private var timerLabelNode: SKLabelNode!
	
    private override init() {
        self.playerArray = []
		self.scoreLabelNodeArray = []
		self.nameLabelNodeArray = []
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
			scoreLabelNodeArray[player].text = "\(playerArray[player].score.currentScore)"
        } else {
            print ("This player not exists")
        }
    }
	
	/// Sets the Hud Scores, Player Names and timer, suports 4 players
	///
	/// - Parameter gameScene: scene that contains the Score, combo, Names labels
	public func setHUD(gameNode: SKNode){

		//Get the Node of the timer
		self.timerLabelNode = gameNode.childNode(withName: "timerLabel") as! SKLabelNode
		self.timer.setLabel(timerLabelNode: self.timerLabelNode)
		self.timer.startTimer()
		// Get the Nodes for each Player
		var i = 1
		for player in playerArray {

			let playerNameNode = gameNode.childNode(withName: "nameLabel\(i)") as! SKLabelNode
			playerNameNode.isHidden = false
			playerNameNode.text = player.playerName + ":"
			self.nameLabelNodeArray.append(playerNameNode)

			let playerScoreNode = gameNode.childNode(withName: "scoreLabel\(i)") as! SKLabelNode
			playerScoreNode.isHidden = false
			self.scoreLabelNodeArray.append(playerScoreNode)

			i+=1
		}
	}
}
