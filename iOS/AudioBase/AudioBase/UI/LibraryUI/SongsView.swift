//
//  SongsView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import UIKit

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
            self.audioPlayer.play(songName: "\(self.audioInfo.title).mp3")
        }) {
            VStack (alignment: .leading, spacing: 5) {
                Text(self.audioInfo.title)
                    .font(.system(size: Constants.SONG_TITLE_SIZE))
                    .font(.title)
                    .fontWeight(.light)
                Text(self.audioInfo.artist)
                    //.font(.footnote)
                    .font(.system(size: Constants.SONG_ARTIST_SIZE))
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct SongsView: View {
    @State var indexPathToSetVisible: IndexPath?
    var body: some View {
        // List of all songs
        VStack {
            // Play and shuffle button
            PlayShuffleButtons().padding(.top, 15)
            Divider()
            //TableViewControllerWrapper()
            
            // List of all songs
            List {
                ForEach(getAllAudioInfoArray(), id: \.self.title) {audioInfo in
                    SongRow(audioInfo: audioInfo)
                }
            }.overlay(
                ScrollManagerView(indexPathToSetVisible: $indexPathToSetVisible)
                    .allowsHitTesting(false).frame(width: 0, height: 0)
            ).navigationBarTitle("Songs")
            .navigationBarItems(
            leading:
                Button("Scroll to top") {
                    self.indexPathToSetVisible = IndexPath(
                        row: 0, section: 0
                    )
                },
            trailing:
                Button("Add") {
            })
            
            // Currently playing section
            PlayerButtons()
        }
    }
}



struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongRow(audioInfo: AudioInfo(title: "I'm Yours", artist: "Jason Mraz", fileURL: URL(fileURLWithPath: ""))).environmentObject(AudioPlayer())
    }
}
