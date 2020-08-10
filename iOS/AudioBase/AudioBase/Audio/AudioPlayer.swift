//
//  PlayAudio.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import AVFoundation

//var player: AVAudioPlayer!

class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer!
    
    @Published var isPlaying: Bool = false

    func play(songName: String) {
        let filename = songNameToFilename(songName: songName)
        let localURL = getAudioFileURL(audioFilename: filename)
        print(localURL)
        do {
            self.player = try AVAudioPlayer(contentsOf: localURL)
            self.player.prepareToPlay()
            self.player.play()
            self.isPlaying = true
        } catch {
            print(error)
        }
    }

    func pause() {
        self.player?.pause()
        self.isPlaying = false
    }
    
    func resume() {
        self.player.play()
        self.isPlaying = true
    }

    func stop() {
        self.player.stop()
        self.isPlaying = false
    }
}



