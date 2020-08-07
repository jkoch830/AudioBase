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
    var body: some View {
        VStack {
            Button(action: {
                print("NOTHINGs")
                   }) {
                       Text("DOWNLOAD")
                   }
            Button(action: {
                print(getAllMP3Files())
                print(getDocumentsDirectory())
            }) {
                Text("TEST")
            }
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}
