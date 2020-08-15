//
//  PlaylistsView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import AVFoundation


struct AllPlaylistsView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    @State var showingNewPlaylistView: Bool = false
    
    func delete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let title = self.audioFileManager.getSortedPlaylists()[index].playlistTitle
            self.audioFileManager.deletePlaylist(title: title)
        }

    }
    
    var body: some View {
        List {
            Button(action: {
                self.showingNewPlaylistView.toggle()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(self.colorHolder.selected())
                    Text("New Playlist...")
                        .foregroundColor(self.colorHolder.selected())
                }
            }.sheet(isPresented: self.$showingNewPlaylistView) {
                NewPlaylistView(showingNewPlaylistView: self.$showingNewPlaylistView)
                    .environmentObject(self.colorHolder)
                    .environmentObject(self.audioFileManager)
            }
            ForEach(self.audioFileManager.getSortedPlaylists(), id: \.self) { playlist in
                NavigationLink(destination:
                    PlaylistView(allAudioInfo: self.audioFileManager.allAudioInfo,
                                 playlist: playlist,
                                 newPlaylistTitle: playlist.playlistTitle,
                                 newSelectedSongs: playlist.songTitles)) {
                    Text(playlist.playlistTitle)
                }
            }.onDelete(perform: self.delete)
        }.navigationBarTitle("Playlists")
    }
}

