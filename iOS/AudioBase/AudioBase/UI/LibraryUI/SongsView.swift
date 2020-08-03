//
//  SongsView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var colorHolder: ColorHolder
    var body: some View {
        Button(action: {
            // Play First song and start queue
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
    var body: some View {
        Button(action: {
            // Play random song and start queue
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
    var body: some View {
        HStack {
            Spacer()
            PlayButton()
            Spacer()
            ShuffleButton()
            Spacer()
        }
    }
}

struct PlayerButtons: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var body: some View {
        HStack {
            Button(action: {
                if self.audioPlayer.isPlaying {
                    self.audioPlayer.pause()
                } else {
                    self.audioPlayer.resume()
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

struct SongRow: View {
    let audioInfo: AudioInfo
    @EnvironmentObject var audioPlayer: AudioPlayer
    var body: some View {
        Button(action: {
            self.audioPlayer.play(filename: "\(self.audioInfo.title).mp3")
        }) {
            Text(self.audioInfo.title)
        }
    }
}

struct SongsView: View {
    var body: some View {
        // List of all songs
        VStack {
            // Play and shuffle button
            PlayShuffleButtons().padding(.top, 15)
            Divider()
            
            // List of all songs
            List {
                ForEach(getAllAudioInfoArray(), id: \.self.title) {audioInfo in
                    SongRow(audioInfo: audioInfo)
                }
            }.navigationBarTitle("Songs")
            
            // Currently playing section
            PlayerButtons()
        }
    }
}

struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
    }
}
