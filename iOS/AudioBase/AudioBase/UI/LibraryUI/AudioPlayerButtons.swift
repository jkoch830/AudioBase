//
//  AudioPlayerButtons.swift
//  AudioBase
//
//  Created by James Koch on 8/15/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

func playAction(audioPlayer: AudioPlayer, audioFileManager: AudioFileManager) {
    if audioPlayer.isPlaying {
        audioPlayer.pause()
    } else if audioPlayer.hasCurrentAudio() {
        audioPlayer.resume()
    } else if audioPlayer.finishedQueue() {
        audioPlayer.restartQueue()
    } else {
        audioPlayer.shuffle(audioInfoSelection:
            audioFileManager.getSortedAudioInfo(sortByTitle: true))
    }
}

struct PlayButton: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @EnvironmentObject var audioPlayer: AudioPlayer
    let audioInfo: [AudioInfo]
    var body: some View {
        Button(action: {
            self.audioPlayer.startQueue(audioInfoSelection: self.audioInfo)
        }) {
            HStack {
                Image(systemName: "play.fill").foregroundColor(colorHolder.selected())
                Text("Play").foregroundColor(colorHolder.selected())
            }
            .frame(width: Constants.SONGS_BUTTONS_WIDTH, height: Constants.SONGS_BUTTONS_HEIGHT)
            .background(Color(.systemGray6))
            .cornerRadius(Constants.SONGS_BUTTONS_CORNER_RADIUS)
        }
    }
}

struct ShuffleButton: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @EnvironmentObject var audioPlayer: AudioPlayer
    let audioInfo: [AudioInfo]
    var body: some View {
        Button(action: {
            self.audioPlayer.shuffle(audioInfoSelection: self.audioInfo)
        }) {
            HStack {
                Image(systemName: "shuffle").foregroundColor(colorHolder.selected())
                Text("Shuffle").foregroundColor(colorHolder.selected())
            }
            .frame(width: Constants.SONGS_BUTTONS_WIDTH, height: Constants.SONGS_BUTTONS_HEIGHT)
            .background(Color(.systemGray6))
            .cornerRadius(Constants.SONGS_BUTTONS_CORNER_RADIUS)
        }
    }
}

/// Stack container for the Play button and Shuffle button
struct PlayShuffleButtons: View {
    let audioInfo: [AudioInfo]
    var body: some View {
        HStack {
            Spacer()
            PlayButton(audioInfo: self.audioInfo)
            Spacer()
            ShuffleButton(audioInfo: self.audioInfo)
            Spacer()
        }
    }
}


struct PlayerButtons: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioFileManager: AudioFileManager
    @State var showingQueue: Bool = false
    
    var playerButtons: some View {
        HStack(spacing: Constants.PLAYER_BUTTONS_PADDING) {
            // Play/pause button
            Button(action: {
                playAction(audioPlayer: self.audioPlayer, audioFileManager: self.audioFileManager)
            }) {
                Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: Constants.PLAY_BUTTON_WIDTH,
                           height: Constants.PLAYER_BUTTONS_HEIGHT)
            }
            // Next button
            Button(action: {
                self.audioPlayer.next()
            }) {
                Image(systemName: "forward.fill")
                .resizable()
                    .frame(width: Constants.FORWARD_BUTTON_WIDTH,
                           height: Constants.PLAYER_BUTTONS_HEIGHT)
            }
        }
    }
    
    var overlayView: some View {
        HStack {
            Text(self.audioPlayer.currentAudioInfo == nil ? "Not Playing" :
                 self.audioPlayer.currentAudioInfo!.title)
                .padding(.leading, Constants.PLAYER_BUTTONS_PADDING)
            Spacer()
            self.playerButtons
                .padding(.trailing, Constants.PLAYER_BUTTONS_PADDING)
        }
    }
    
    var body: some View {
        Button(action: {
            self.showingQueue.toggle()
        }) {
            Color(UIColor.systemGray6)
                .frame(width: Constants.DEVICE_WIDTH, height: Constants.PLAYER_BUTTONS_ROW_HEIGHT)
        }
        .sheet(isPresented: self.$showingQueue) {
            QueueView()
                .environmentObject(self.audioPlayer)
                .environmentObject(self.audioFileManager)
        }
        .overlay(self.overlayView)
    }
}
