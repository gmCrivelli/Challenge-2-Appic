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
    var audioPlayer = AVAudioPlayer()
    
    private init() { } // private singleton init
    
    /// loading music (circus music)
    func setup() {
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "circusSound", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
        } catch {
            print (error)
        }
    }
    
    /// plays the music
    func play() {
        audioPlayer.play()
    }
    
    /// stops the music
    func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.prepareToPlay()
    }

}
