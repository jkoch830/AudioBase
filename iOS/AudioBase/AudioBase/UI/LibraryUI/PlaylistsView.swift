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
                       downloadMP3FromStorage(filename: "testfile2.mp3")
                   }) {
                       Text("DOWNLOAD")
                   }
            Button(action: {
                do {
                    // Get the directory contents urls (including subfolders urls)
                    let dir: URL = getDocumentsDirectory().appendingPathComponent("audio/")
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
                    print(directoryContents)

                    // if you want to filter the directory contents you can do like this:
                    let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
                    print("mp3 urls:",mp3Files)
                    let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
                    print("mp3 list:", mp3FileNames)

                } catch {
                    print(error)
                }
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
