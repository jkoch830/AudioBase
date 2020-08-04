//
//  SearchView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct SaveButton: View {
    var body: some View {
        Button(action: {
            
        }) {
            Text("Save").frame(width: Constants.DEVICE_WIDTH / 4,
                               height: Constants.DEVICE_HEIGHT / 12)
        }
    }
}

struct SearchView: View {
    var webView: YoutubeWebView = YoutubeWebView()
    var body: some View {
        VStack {
            Button(action: {
                print(self.webView.getCurrentURL())
            }) {
                Text("Save").frame(width: Constants.DEVICE_WIDTH / 4,
                                   height: Constants.DEVICE_HEIGHT / 12)
            }
            self.webView
        }
    }
}
//
//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
