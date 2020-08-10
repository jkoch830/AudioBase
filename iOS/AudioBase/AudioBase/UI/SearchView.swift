//
//  SearchView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct DownloadAudioView: View {
    @ObservedObject var colorHolder: ColorHolder
    @ObservedObject var audioFileManager: AudioFileManager
    let youtubeURL: String
    @State var title: String = ""
    @State var artist: String = ""
    @Binding var showingView: Bool
    var body: some View {
        NavigationView {
            VStack {
                // Music info
                Form {
                    Section {
                        TextField("Title", text: self.$title)
                    }
                    Section {
                        TextField("Artist", text: self.$artist)
                    }
                }
                // Download Button
                Button(action: {
                    let fixSingleQuote = self.title.replacingOccurrences(of: "’", with: "'")
                    self.audioFileManager.downloadNewAudio(youtubeURL: self.youtubeURL,
                                                           title: fixSingleQuote,
                                                           artist: self.artist)
                    self.showingView = false
                }) {
                    Text("Download").foregroundColor(self.colorHolder.selected())
                }.padding(.vertical, 100)
            }.navigationBarItems(
                    leading: Button(action: {self.showingView = false}) {
                        Text("Cancel").foregroundColor(self.colorHolder.selected())
            })
        }
    }
}

struct SearchView: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @EnvironmentObject var audioFileManager: AudioFileManager
    @State var showingDownload: Bool = false
    var webView: YoutubeWebView = YoutubeWebView()
    var body: some View {
        VStack {
            Button(action: {
                self.showingDownload.toggle()
            }) {
                Text("Download").frame(width: Constants.DEVICE_WIDTH / 4,
                                   height: Constants.DEVICE_HEIGHT / 12)
            }.sheet(isPresented: self.$showingDownload) {
                DownloadAudioView(colorHolder: self.colorHolder,
                                  audioFileManager: self.audioFileManager,
                                  youtubeURL: self.webView.getCurrentURL(),
                                  showingView: self.$showingDownload)
            }
            self.webView
        }
    }
}
