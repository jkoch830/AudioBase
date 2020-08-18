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
    private var fullQueue: [AudioInfo] = [AudioInfo]()
    private var fullQueueIndex: Int = 0
    private var queueAVItems: [AVPlayerItem] = [AVPlayerItem]()
    
    @Published var isPlaying: Bool = false
    @Published var currentAudioInfo: AudioInfo?
    @Published var currentQueue: [AudioInfo] = [AudioInfo]()
    
    init() {
        self.player = AVQueuePlayer()
        self.addEndObserver()
    }
    
    func playSingle(audioInfo: AudioInfo) {
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
        self.queueAVItems = self.audioInfoToItem(audioInfo: audioInfoSelection)
        for item in self.queueAVItems {
            self.player.insert(item, after: nil)
        }
        self.player.play()
        self.isPlaying = true
        
        var audioInfoSelection = audioInfoSelection
        self.fullQueue = audioInfoSelection
        self.fullQueueIndex = 0
        self.currentAudioInfo = audioInfoSelection.removeFirst()
        self.currentQueue = audioInfoSelection
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
        self.player.seek(to: .zero)
        self.updateQueue(next: true)
    }
    
    func previous() {
        if self.player.currentItem != nil && self.player.currentItem!.currentTime().seconds > 4  {
            self.restart(play: self.isPlaying)
        } else if self.fullQueueIndex > 0 {  // More songs to be played previously
            let prev: AVPlayerItem = self.queueAVItems[fullQueueIndex - 1]
            if let curr = self.player.currentItem {
                self.player.replaceCurrentItem(with: prev)
                self.player.insert(curr, after: prev)
            } else {  // Finished queue
                self.player.insert(prev, after: nil)
            }
            self.player.seek(to: .zero)
            if self.isPlaying {
                self.player.play()
            }
            self.updateQueue(next: false)
        } else {   // On first song of queue, so restart it
            self.restart(play: self.isPlaying)
        }
    }

    func pause() {
        self.player.pause()
        self.isPlaying = false
    }
    
    func resume() {
        self.player.play()
        self.isPlaying = true
    }
    
    func restart(play: Bool) {
        if let current = self.player.currentItem {
            self.player.replaceCurrentItem(with: current)
            self.player.seek(to: .zero)
            if play {
                self.player.play()
            }
        }
    }
    
    func restartQueue() {
        self.startQueue(audioInfoSelection: self.fullQueue)
    }
    
    func finishedQueue() -> Bool {
        return self.fullQueue.count == self.fullQueueIndex && self.fullQueue.count > 0
    }
    
    func updateQueue(next: Bool) {
        if next {
            if self.fullQueueIndex < self.fullQueue.count {
                self.fullQueueIndex += 1
            }
            if self.currentQueue.count > 0 {
                self.currentAudioInfo = self.fullQueue[self.fullQueueIndex]
                self.currentQueue = Array(self.fullQueue.suffix(from: self.fullQueueIndex + 1))
            } else {   // Queue is complete
                self.currentAudioInfo = nil
                self.isPlaying = false
            }
        } else {
            if self.fullQueueIndex > 0 {  // More songs to be played previously
                self.fullQueueIndex -= 1
                self.currentAudioInfo = self.fullQueue[self.fullQueueIndex]
                self.currentQueue = Array(self.fullQueue.suffix(from: self.fullQueueIndex + 1))
            }
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
        self.updateQueue(next: true)
    }
    
    private func audioInfoToItem(audioInfo: [AudioInfo]) -> [AVPlayerItem] {
        return audioInfo.map { audioInfo in
            let filename = songNameToFilename(songName: audioInfo.title)
            let localURL = getAudioFileURL(audioFilename: filename)
            return AVPlayerItem(url: localURL)
        }
    }
}


