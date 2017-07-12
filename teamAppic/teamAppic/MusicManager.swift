//
//  MusicManager.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 10/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MusicManager {
    
    /// singleton
    static let instance = MusicManager()
    
    /// audioPlayer
    var gameAudioPlayer = AVAudioPlayer()
    var gameOverAudioPlayer = AVAudioPlayer()
    
    private init() { } // private singleton init
    
    /// loading music (circus music)
    func setupGame() {
        do {
            gameAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "circusSound", ofType: "mp3")!))
            gameAudioPlayer.prepareToPlay()
            
        } catch {
            print (error)
        }
    }
    
    /// loading Game Over music (circus music)
    func setupGameOver() {
        do {
            gameOverAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "mp3")!))
            gameOverAudioPlayer.prepareToPlay()
            
        } catch {
            print (error)
        }
    }
    
    /// plays the music
    func playGameAudio() {
        gameAudioPlayer.play()
    }
    
    /// stops the music
    func stopGameAudio() {
        gameAudioPlayer.stop()
        gameAudioPlayer.currentTime = 0
        gameAudioPlayer.prepareToPlay()
    }
    
    /// plays the Game Over music
    func playGameOverAudio() {
        gameOverAudioPlayer.play()
    }
    
    /// stops the Game Over music
    func stopGameOverAudio() {
        gameOverAudioPlayer.stop()
        gameOverAudioPlayer.currentTime = 0
        gameOverAudioPlayer.prepareToPlay()
    }

}
