//
//  PlayAudio.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import AVFoundation

var player: AVAudioPlayer!

func startPlayer(filename: String) {
    let localURL = getAudioDirectory(audioFilename: filename)
    do {
        player = try AVAudioPlayer(contentsOf: localURL)
        player.prepareToPlay()
        player.play()
    } catch {
        print(error)
    }
}

func pausePlayer() {
    player.pause()
}

func stopPlayer() {
    player.stop()
}
