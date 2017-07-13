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
    var menuAudioPlayer = AVAudioPlayer()
    
    /// minimum/maximum audio Volume
    let minimumVolume: Float = 0.2
    let maximumVolume: Float = 1.0
    
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
    
    /// loading Game Over music
    func setupGameOver() {
        do {
            gameOverAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "mp3")!))
            gameOverAudioPlayer.prepareToPlay()
            
        } catch {
            print (error)
        }
    }
    
    /// loading Menu music
    func setupMenu() {
        do {
            menuAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "menu", ofType: "mp3")!))
            menuAudioPlayer.prepareToPlay()
            
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
    
    /// Get the game audio volume down
    func lowGameAudio() {
        gameAudioPlayer.volume = minimumVolume
    }
    
    /// Get the game audio volume up
    func highGameAudio() {
        gameAudioPlayer.volume = maximumVolume
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
    
    /// plays the menu music
    func playMenuAudio() {
        menuAudioPlayer.play()
    }
    
    /// stops the menu music
    func stopMenuAudio() {
        menuAudioPlayer.stop()
        menuAudioPlayer.currentTime = 0
        menuAudioPlayer.prepareToPlay()
    }
}
