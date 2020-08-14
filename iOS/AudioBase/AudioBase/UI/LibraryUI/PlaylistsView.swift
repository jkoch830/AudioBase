//
//  PlaylistsView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PlaylistsView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    var body: some View {
        List {
            ForEach(self.audioFileManager.getSortedPlaylists(), id: \.self) { playlist in
                Text(playlist.playlistTitle)
            }
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}
