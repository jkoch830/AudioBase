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
        if self.editMode {
            indexSet.forEach { index in
                self.newSelectedSongs.remove(at: index)
            }
        }
    }
    
    func onlyPlaylistAudioInfo() -> [AudioInfo] {
        var res = [AudioInfo]()
        for songTitle in self.playlist.songTitles {
            res.append(self.allAudioInfo[songTitle]!)
        }
        return res
    }
    
    var body: some View {
        VStack {
            if self.editMode {
                VStack(alignment: .leading) {
                    TextField(self.newPlaylistTitle, text: self.$newPlaylistTitle)
                        .font(.largeTitle)
                    NavigationLink(destination:
                            PlaylistSongSelectionView(selectedSongs: $newSelectedSongs)) {
                        Text("Add Music...").foregroundColor(self.colorHolder.selected())
                    }
                }
                .padding(.leading, 10)
                .transition(.asymmetric(insertion: .move(edge: .leading),
                                        removal: .move(edge: .trailing)))
                .animation(.easeInOut)
            } else {
                PlayShuffleButtons(audioInfo: self.onlyPlaylistAudioInfo())
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .move(edge: .leading)))
                    .animation(.easeInOut)
            }
            List {
                ForEach(self.newSelectedSongs, id: \.self) { songTitle in
                    PlayableSongRow(audioInfo: self.allAudioInfo[songTitle]!)
                }.onDelete(perform: self.delete).deleteDisabled(!self.editMode)
            }
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
            .environment(\.editMode, .constant(self.editMode ? EditMode.active : EditMode.inactive))
                .animation(.spring())
    }
}

