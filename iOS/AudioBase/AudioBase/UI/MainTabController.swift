//
//  MainTabController.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import SwiftUI

struct MainTabController: View {
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
        }
    }
}
