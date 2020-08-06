//
//  LibraryView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct ColorPicker: View {
    @EnvironmentObject var colorHolder: ColorHolder
    @State var currentColor: Color = Color.blue
    var body: some View {
        Button(action: {self.colorHolder.toggle()}) {
            Image(systemName: "eyedropper.full")
        }
    }
}

struct LibraryView: View {
    @EnvironmentObject var colorHolder: ColorHolder
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: PlaylistsView()) {
                        Text("Playlists")
                            .font(.system(size: 25))
                            .foregroundColor(colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                    NavigationLink(destination: ArtistsView()) {
                        Text("Artists")
                            .font(.system(size: 25))
                            .foregroundColor(colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                    NavigationLink(destination: SongsView()) {
                        Text("Songs")
                            .font(.system(size: 25))
                            .foregroundColor(colorHolder.selected())
                            .padding(.vertical, 5)
                    }
                    }.navigationBarTitle("Library").navigationBarItems(trailing: ColorPicker())
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
