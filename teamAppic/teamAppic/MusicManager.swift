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
    
    /// menu sound volume
    let menuVolume: Float = 0.3
    
    /// menu sound volume
    let gameVolume: Float = 1
    
    /// menu sound volume
    let gameOverVolume: Float = 1

    /// boolean that indicates if there is sound in the game
    public private (set) var volumeSound : Bool = true
    
    private init() { } // private singleton init
    
    /// loading music (circus music)
    private func setupGame() {
        do {
            gameAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "circusSound", ofType: "mp3")!))
            gameAudioPlayer.prepareToPlay()
            // initial volume
            gameAudioPlayer.volume = gameVolume
            
        } catch {
            print (error)
        }
    }
    
    /// loading Game Over music
    private func setupGameOver() {
        do {
            gameOverAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "mp3")!))
            gameOverAudioPlayer.prepareToPlay()
            // initial volume
            gameOverAudioPlayer.volume = gameOverVolume
            
        } catch {
            print (error)
        }
    }
    
    /// loading Menu music
    private func setupMenu() {
        do {
            menuAudioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "menuSound", ofType: "mp3")!))
            menuAudioPlayer.prepareToPlay()
            // initial volume
            menuAudioPlayer.volume = menuVolume
            
        } catch {
            print (error)
        }
    }
    
    /// loading all game musics
    func setupMusics() {
        setupGame()
        setupMenu()
        setupGameOver()
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
        if (self.volumeSound) {
            gameAudioPlayer.volume = minimumVolume
        } else {
            gameAudioPlayer.volume = 0
        }
    }
    
    /// get the game volume to mute, and when it is called again, to dismute
    func pressGameAudio() {
        self.volumeSound = !self.volumeSound
        mute()
    }
    
    /// Get the game audio volume up
    func highGameAudio() {
        if (self.volumeSound) {
            gameAudioPlayer.volume = maximumVolume
        } else {
            gameAudioPlayer.volume = 0
        }
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
    
    /// plays the menu music with low volume
    func playMenuAudio() {
        menuAudioPlayer.numberOfLoops = -1
        menuAudioPlayer.play()
    }
    
    /// stops the menu music
    func stopMenuAudio() {
        menuAudioPlayer.stop()
        menuAudioPlayer.currentTime = 0
        menuAudioPlayer.prepareToPlay()
    }
    
    /// function that mutes all sounds
    func mute() {
        if (self.volumeSound) {
            menuAudioPlayer.volume = menuVolume
            gameAudioPlayer.volume = gameVolume
            gameOverAudioPlayer.volume = gameOverVolume
        } else {
            menuAudioPlayer.volume = 0
            gameAudioPlayer.volume = 0
            gameOverAudioPlayer.volume = 0
        }
    }
}
