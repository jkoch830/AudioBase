//
//  NewPlaylistView.swift
//  AudioBase
//
//  Created by James Koch on 8/15/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct NewPlaylistView: View {
    @State var playlistName: String = ""
    @State var selectedSongs: [String] = [String]()
    @Binding var showingNewPlaylistView: Bool
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    
    func delete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            self.selectedSongs.remove(at: index)
        }
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    TextField("Playlist Name", text: self.$playlistName)
                        .multilineTextAlignment(.center)
                        .font(.title)
                }.padding(.top, Constants.NEW_PLAYLIST_TITLE_PADDING)
                Divider()
                List {
                    NavigationLink(destination:
                        PlaylistSongSelectionView(selectedSongs: $selectedSongs)) {
                       HStack {
                            Image(systemName: "plus.circle.fill").foregroundColor(.green)
                            Text("Add Music").foregroundColor(self.colorHolder.selected())
                       }
                   }
                    ForEach(selectedSongs, id: \.self) { selectedSong in
                        Text(selectedSong)
                    }.onDelete(perform: self.delete)
                }.onAppear {
                    UITableView.appearance().showsVerticalScrollIndicator = false
                }
                
            }
            .navigationBarTitle("New Playlist", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Cancel") {
                    self.showingNewPlaylistView = false
                }.foregroundColor(self.colorHolder.selected()),
                trailing:
                Button("Done") {
                    if self.playlistName != "" {
                        self.audioFileManager.addPlaylist(title: self.playlistName,
                                                          songs: self.selectedSongs)
                    }
                    self.showingNewPlaylistView = false
                }.foregroundColor(self.colorHolder.selected()))
        }
    }
}
