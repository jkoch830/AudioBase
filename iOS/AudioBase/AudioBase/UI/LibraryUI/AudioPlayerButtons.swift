//
//  AudioPlayerButtons.swift
//  AudioBase
//
//  Created by James Koch on 8/15/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

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
    let audioInfo: [AudioInfo]
    var body: some View {
        HStack {
            Button(action: {
                if self.audioPlayer.isPlaying {
                    self.audioPlayer.pause()
                } else if self.audioPlayer.hasCurrentAudio() {
                    self.audioPlayer.resume()
                } else {
                    self.audioPlayer.shuffle(audioInfoSelection: self.audioInfo)
                }
                
            }) {
                if self.audioPlayer.isPlaying {
                    Image(systemName: "pause.fill")
                    .resizable()
                    .frame(width: 20, height: Constants.SONG_ROW_HEIGHT / 3)
                } else {
                    Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 20, height: Constants.SONG_ROW_HEIGHT / 3)
                }
            }
        }.frame(width: Constants.DEVICE_WIDTH, height: Constants.SONG_ROW_HEIGHT)
            .background(Color(UIColor.systemGray6))
    }
}