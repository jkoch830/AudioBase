//
//  MainTabController.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseStorage

struct MainTabController: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @EnvironmentObject var audioFileManager: AudioFileManager
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("Library")
            }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            DownloadsView(taskContainer: self.audioFileManager.downloadTaskContainer)
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Downloads")
            }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }.accentColor(colorHolder.selected())
    }
}

struct MainTabController_Preview: PreviewProvider {

    static var previews: some View {
        MainTabController().environmentObject(ColorHolder())
    }
}
