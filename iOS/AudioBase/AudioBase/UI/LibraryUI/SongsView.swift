//
//  SongsView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import UIKit

struct PlayableSongRow: View {
    let audioInfo: AudioInfo
    @State var pushed: Bool = false
    @State var showContext = false
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioFileManager: AudioFileManager

    var body: some View {
        Button(action: {
            self.audioPlayer.playSingle(audioInfo: self.audioInfo)
        }) {
            VStack (alignment: .leading, spacing: 5) {
                Text(self.audioInfo.title)
                    .font(.system(size: Constants.SONG_TITLE_SIZE))
                    .font(.title)
                    .fontWeight(.light)
                Text(self.audioInfo.artist)
                    .font(.system(size: Constants.SONG_ARTIST_SIZE))
                    .foregroundColor(Color.gray)
            }.contextMenu {
                Button(action: {

                }) {
                    HStack {
                        Text("Play Next")
                        Image(systemName: "text.insert")
                    }
                }
                Button(action: {

                }) {
                    HStack {
                        Text("Play Later")
                        Image(systemName: "text.append")
                    }
                }
                Button(action: {
                    self.audioFileManager.deleteAudioInfo(title: self.audioInfo.title)
                }) {
                    HStack {
                        Text("Edit")
                        Image(systemName: "trash")
                    }
                }
                Button(action: {
                    self.audioFileManager.deleteAudioInfo(title: self.audioInfo.title)
                }) {
                    HStack {
                        Text("Delete from Library")
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

struct MyButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .onLongPressGesture(
                minimumDuration: 0,
                perform: configuration.trigger
        )
    }
}

struct SectionShortcuts: View {
    let sortedSections: [Character]
    let sectionIndices: [Character: Int]
    @Binding var indexPathToSetVisible: IndexPath?
    @EnvironmentObject var colorHolder: ColorHolder
    
    func setIndexPath(_ section: Character) {
        let sectionIndices = self.sectionIndices
        self.indexPathToSetVisible = IndexPath(
            row: 0, section: sectionIndices[section]!
        )
    }

    var body: some View {
        VStack {
            ForEach(self.sortedSections, id: \.self) { section in
                Button(action: {
                    self.setIndexPath(section)
                }) {
                    Text(String(section))
                        .font(.system(size: Constants.SECTION_INDEX_WIDTH))
                        .foregroundColor(self.colorHolder.selected())
                        .frame(width: Constants.SECTION_INDEX_WIDTH,
                               height: Constants.SECTION_INDEX_WIDTH)
                        .background(Color(UIColor.systemGray6))
                }.buttonStyle(MyButtonStyle())
            }
        }
    }
}

struct SongsView: View {
    let scrollManager = ScrollManager()
    @State var indexPathToSetVisible: IndexPath?
    @State var sortByTitle: Bool = true
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    
    
    var tableViewFinderOverlay: AnyView {
        if scrollManager.tableView == nil {
            return AnyView(TableViewFinder(scrollManager: scrollManager))
        }
        return AnyView(EmptyView())
    }
    
    func getSortedAudioInfo() -> [AudioInfo] {
        return self.audioFileManager.getSortedAudioInfo(sortByTitle: self.sortByTitle)
    }
    
    func getSortedSections() -> [Character] {
        let allSections = self.getAllSectionIndices()
        return Array(allSections.keys).sorted()
    }
    
    func getAllSectionIndices() -> [Character: Int] {
        let sortedInfo = self.getSortedAudioInfo()
        var allSections: [Character: Int] = [Character: Int]()
        for i in 0..<sortedInfo.count {
            let currInfo = sortedInfo[i]
            let firstLetter = self.sortByTitle ? currInfo.title.first! : currInfo.artist.first!
            if allSections[firstLetter] == nil {
                allSections[firstLetter] = allSections.count
            }
        }
        return allSections
    }
    
    func getSectionalAudioInfo() -> [Character: [AudioInfo]] {
        var res: [Character: [AudioInfo]] = [Character: [AudioInfo]]()
        for audioInfo in self.getSortedAudioInfo() {
            let firstLetter = self.sortByTitle ? audioInfo.title.first! : audioInfo.artist.first!
            if res[firstLetter] == nil {
                res[firstLetter] = [AudioInfo]()
            }
            var currList = res[firstLetter]
            currList?.append(audioInfo)
            res.updateValue(currList!, forKey: firstLetter)
        }
        return res
    }
    
    var body: some View {
        VStack {
            PlayShuffleButtons(audioInfo: self.getSortedAudioInfo())
            HStack(spacing: 0) {
                // Sort all songs by section
                List {
                    // Play and shuffle button
                    ForEach(Array(self.getSortedSections()), id: \.self) { char in
                        Section(header: Text(String(char))) {
                            ForEach(self.getSectionalAudioInfo()[char]!, id: \.self.title) { info in
                                PlayableSongRow(audioInfo: info)
                                    .overlay(self.tableViewFinderOverlay.frame(width: 0, height: 0))
                            }
                        }
                    }
                }
                .navigationBarTitle("Songs")
                .navigationBarItems(trailing:
                    Text("Sort").foregroundColor(self.colorHolder.selected())
                        .contextMenu {
                            Button("Artist") {
                                self.sortByTitle = false
                            }.foregroundColor(self.colorHolder.selected())
                            Button("Title") {
                                self.sortByTitle = true
                            }.foregroundColor(self.colorHolder.selected())
                    }
                )
                .onAppear {
                    UITableView.appearance().showsVerticalScrollIndicator = false
                }
                
                // Section shortcuts
                SectionShortcuts(sortedSections: self.getSortedSections(),
                                 sectionIndices: self.getAllSectionIndices(),
                                 indexPathToSetVisible: self.$indexPathToSetVisible)
                ScrollManagerView(scrollManager: self.scrollManager,
                                    indexPathToSetVisible: $indexPathToSetVisible)
                      .allowsHitTesting(false).frame(width: 0, height: 0)
            }
        }  
    }
    
}

