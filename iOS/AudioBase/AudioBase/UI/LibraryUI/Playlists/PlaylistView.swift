//
//  PlaylistView.swift
//  AudioBase
//
//  Created by James Koch on 8/15/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    let allAudioInfo: [String: AudioInfo]
    @State var playlist: Playlist
    @State var newPlaylistTitle: String
    @State var newSelectedSongs: [String]
    @State var editMode: Bool = false
    
    func delete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            self.newSelectedSongs.remove(at: index)
        }
    }
    
    var body: some View {
        VStack {
            if self.editMode {
                VStack(alignment: .leading) {
                    TextField(self.newPlaylistTitle, text: self.$newPlaylistTitle)
                        .font(.largeTitle)
                    NavigationLink(destination:
                            PlaylistSongSelectionView(selectedSongs: $newSelectedSongs)) {
                        HStack {
                             Image(systemName: "plus.circle.fill").foregroundColor(.green)
                         Text("Add Music").foregroundColor(self.colorHolder.selected())
                        }
                    }
                }
                .padding(.leading, 10)
                .transition(.asymmetric(insertion: .move(edge: .leading),
                                        removal: .move(edge: .trailing)))
                .animation(.easeInOut)
            } else {
                PlayShuffleButtons()
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .move(edge: .leading)))
                    .animation(.easeInOut)
            }
            List {
                if self.editMode {
                    ForEach(self.newSelectedSongs, id: \.self) { songTitle in
                        PlayableSongRow(audioInfo: self.allAudioInfo[songTitle]!)
                    }.onDelete(perform: self.delete)
                } else {
                    ForEach(self.playlist.songTitles, id: \.self) { songTitle in
                        PlayableSongRow(audioInfo: self.allAudioInfo[songTitle]!)
                    }
                }
                
            }
            PlayerButtons()
        }.padding(.top, Constants.NEW_PLAYLIST_TITLE_PADDING)
        .navigationBarBackButtonHidden(self.editMode)
        .navigationBarTitle(Text(self.playlist.playlistTitle), displayMode: .inline)
        .navigationBarItems(
            leading:
            Button(action: {
                self.newPlaylistTitle = self.playlist.playlistTitle
                self.newSelectedSongs = self.playlist.songTitles
                self.editMode.toggle()
                
            }) {
                if self.editMode { Text("Cancel") }
                else { EmptyView() }
            },
            trailing:
            Button(self.editMode ? "Done" : "Edit") {
                if self.editMode {
                    let oldTitle = self.playlist.playlistTitle
                    self.playlist.playlistTitle = self.newPlaylistTitle
                    self.playlist.songTitles = self.newSelectedSongs
                    self.audioFileManager.updatePlaylist(oldTitle: oldTitle,
                                                         newTitle: self.newPlaylistTitle,
                                                         newPlaylist: self.playlist)
                }
                self.editMode.toggle()
            }
        )
    }
}

