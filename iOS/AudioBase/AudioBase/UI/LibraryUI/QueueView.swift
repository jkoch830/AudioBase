//
//  QueueView.swift
//  AudioBase
//
//  Created by James Koch on 8/17/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct QueueSongRow: View {
    let audioInfo: AudioInfo
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.audioInfo.title)
                    .font(.system(size: Constants.SONG_TITLE_SIZE))
                    .font(.title)
                    .fontWeight(.light)
            Text(self.audioInfo.artist)
                    .font(.system(size: Constants.SONG_ARTIST_SIZE))
                    .foregroundColor(Color.gray)
            
        }
    }
}


struct QueueView: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioFileManager: AudioFileManager

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(self.audioPlayer.currentAudioInfo == nil ? "Not Playing" :
                    self.audioPlayer.currentAudioInfo!.title)
                    .fontWeight(.bold)
                if self.audioPlayer.currentAudioInfo != nil {
                    Text(self.audioPlayer.currentAudioInfo!.artist)
                        .font(.system(size: Constants.SONG_ARTIST_SIZE))
                        .foregroundColor(Color.gray)
                }
                Divider()
                Text("Up Next").fontWeight(.bold)
                List {
                    ForEach(self.audioPlayer.currentQueue, id: \.self.title) { audioInfo in
                        QueueSongRow(audioInfo: audioInfo)
                    }
                }
            }.padding([.leading, .top], Constants.QUEUE_PADDING)
        
            HStack(spacing: Constants.QUEUE_PLAYER_BUTTONS_SPACING) {
                Button(action: {
                    self.audioPlayer.previous()
                }) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: Constants.FORWARD_BUTTON_WIDTH,
                               height: Constants.PLAYER_BUTTONS_HEIGHT)
                }
                Button(action: {
                    playAction(audioPlayer: self.audioPlayer,
                               audioFileManager: self.audioFileManager)
                }) {
                    Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                        .frame(width: Constants.QUEUE_PLAY_BUTTON_SIZE,
                               height: Constants.QUEUE_PLAY_BUTTON_SIZE)
                }
                Button(action: {
                    self.audioPlayer.next()
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: Constants.FORWARD_BUTTON_WIDTH,
                               height: Constants.PLAYER_BUTTONS_HEIGHT)
                }
                
            }.padding(.bottom, Constants.QUEUE_PLAYER_BUTTONS_PADDING)
        }
    }
}
