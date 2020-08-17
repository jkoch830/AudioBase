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
    private var player: AVQueuePlayer
    
    @Published var isPlaying: Bool = false
    @Published var currentAudioInfo: AudioInfo?
    @Published var queue: [AudioInfo] = [AudioInfo]()
    
    init() {
        self.player = AVQueuePlayer()
        self.addEndObserver()
    }

    func play(audioInfo: AudioInfo) {
        let filename = songNameToFilename(songName: audioInfo.title)
        let localURL = getAudioFileURL(audioFilename: filename)
        let playerItem: AVPlayerItem = AVPlayerItem(url: localURL)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()
        self.isPlaying = true
        self.currentAudioInfo = audioInfo
    }
    
    func startQueue(audioInfoSelection: [AudioInfo]) {
        self.player.removeAllItems()
        self.player = AVQueuePlayer(items: self.audioInfoToItem(audioInfo: audioInfoSelection))
        self.player.play()
        self.isPlaying = true
        var audioInfoSelection = audioInfoSelection
        self.currentAudioInfo = audioInfoSelection.removeFirst()
        self.queue = audioInfoSelection
    }
    
    func shuffle(audioInfoSelection: [AudioInfo]) {
        let shuffled: [AudioInfo] = audioInfoSelection.shuffled()
        self.startQueue(audioInfoSelection: shuffled)
    }
    
    func hasCurrentAudio() -> Bool {
        return self.currentAudioInfo != nil
    }
    
    func next() {
        self.player.advanceToNextItem()
        self.updateQueue()
    }

    func pause() {
        self.player.pause()
        self.isPlaying = false
    }
    
    func resume() {
        self.player.play()
        self.isPlaying = true
    }
    
    func updateQueue() {
        if self.queue.count > 0 {
            self.currentAudioInfo = self.queue.removeFirst()
        } else {   // Queue is complete
            self.currentAudioInfo = nil
            self.isPlaying = false
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AudioPlayer {
    private func addEndObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil) // Add observer
    }
    
    // Notification Handling
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.updateQueue()
    }
    
    private func audioInfoToItem(audioInfo: [AudioInfo]) -> [AVPlayerItem] {
        return audioInfo.map { audioInfo in
            let filename = songNameToFilename(songName: audioInfo.title)
            let localURL = getAudioFileURL(audioFilename: filename)
            return AVPlayerItem(url: localURL)
        }
    }
}


