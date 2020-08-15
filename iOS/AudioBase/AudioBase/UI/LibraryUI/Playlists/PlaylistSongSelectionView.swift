//
//  PlaylistSongSelectionView.swift
//  AudioBase
//
//  Created by James Koch on 8/15/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

fileprivate struct SongRow: View {
    @Binding var selectedSongs: [String]
    let audioInfo: AudioInfo
    
    func isSelected() -> Bool {
        return self.selectedSongs.contains(self.audioInfo.title)
    }
    
    var body: some View {
        Button(action: {
            // Click already-selected title; remove from selected list
            if self.isSelected() {
                self.selectedSongs = self.selectedSongs.filter { $0 != self.audioInfo.title }
            } else {    // Song is unselected; add to list
                self.selectedSongs.append(self.audioInfo.title)
            }
        }) {
            HStack {
                VStack (alignment: .leading, spacing: 5) {
                    Text(self.audioInfo.title)
                        .font(.system(size: Constants.SONG_TITLE_SIZE))
                        .font(.title)
                        .fontWeight(.light)
                    Text(self.audioInfo.artist)
                        //.font(.footnote)
                        .font(.system(size: Constants.SONG_ARTIST_SIZE))
                        .foregroundColor(Color.gray)
                }
                Spacer()
                if self.isSelected() {
                    Image(systemName: "checkmark")
                } else {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
}


struct PlaylistSongSelectionView: View {
    let scrollManager = ScrollManager()
    @State var indexPathToSetVisible: IndexPath?
    @State var sortByTitle: Bool = true
    @Binding var selectedSongs: [String]
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
        // List of all songs
        HStack(spacing: 0) {
            VStack {
                // Sort all songs by section
                List {
                    ForEach(Array(self.getSortedSections()), id: \.self) { char in
                        Section(header: Text(String(char))) {
                            ForEach(self.getSectionalAudioInfo()[char]!, id: \.self.title) { info in
                                SongRow(selectedSongs: self.$selectedSongs, audioInfo: info)
                                    .overlay(self.tableViewFinderOverlay.frame(width: 0, height: 0))
                            }
                        }
                    }
                }
                .navigationBarTitle("Songs", displayMode: .inline)
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
