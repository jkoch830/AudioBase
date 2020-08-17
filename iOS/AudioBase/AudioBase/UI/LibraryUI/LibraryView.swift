//
//  LibraryView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI


struct LibraryView: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @EnvironmentObject var audioFileManager: AudioFileManager
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination:
                        AllPlaylistsView()
                            .padding(.bottom, Constants.PLAYER_BUTTONS_ROW_HEIGHT)) {
                        Text("Playlists")
                            .font(.system(size: 25))
                            .foregroundColor(self.colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                    NavigationLink(destination:
                        ArtistsView()
                            .padding(.bottom, Constants.PLAYER_BUTTONS_ROW_HEIGHT)) {
                        Text("Artists")
                            .font(.system(size: 25))
                            .foregroundColor(self.colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                    NavigationLink(destination:
                        SongsView()
                            .padding(.bottom, Constants.PLAYER_BUTTONS_ROW_HEIGHT)) {
                        Text("Songs")
                            .font(.system(size: 25))
                            .foregroundColor(self.colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                }.navigationBarTitle("Library")
            }
        }.overlay(VStack {
            Spacer()
            PlayerButtons(audioInfo: self.audioFileManager.getSortedAudioInfo(sortByTitle: true))
        })
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
