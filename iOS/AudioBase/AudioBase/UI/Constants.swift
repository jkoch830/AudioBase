//
//  Constants.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import SwiftUI

struct Constants {
    static let DEVICE_WIDTH = UIScreen.main.bounds.width
    static let DEVICE_HEIGHT = UIScreen.main.bounds.height
    static let SONGS_BUTTONS_WIDTH = Constants.DEVICE_WIDTH * 5 / 12
    static let SONGS_BUTTONS_HEIGHT = Constants.DEVICE_HEIGHT / 16
    static let SONGS_BUTTONS_CORNER_RADIUS = CGFloat(10)
    static let SONG_ROW_HEIGHT = Constants.DEVICE_HEIGHT / 10
    static let SONG_TITLE_SIZE = CGFloat(20)
    static let SONG_ARTIST_SIZE = CGFloat(15)
    static let SECTION_INDEX_WIDTH = CGFloat(15)
    static let NEW_PLAYLIST_TITLE_PADDING = CGFloat(20)
    
    // Buttons
    static let ADD_BUTTON_SIZE = CGFloat(22)
    static let PLAY_BUTTON_WIDTH = CGFloat(20)
    static let FORWARD_BUTTON_WIDTH = CGFloat(40)
    static let PLAYER_BUTTONS_ROW_HEIGHT = Constants.DEVICE_HEIGHT / 10
    static let PLAYER_BUTTONS_PADDING = CGFloat(20)
    static let PLAYER_BUTTONS_HEIGHT = Constants.PLAYER_BUTTONS_ROW_HEIGHT / 3
    
    static let QUEUE_PADDING = CGFloat(20)
    static let QUEUE_PLAY_BUTTON_SIZE = CGFloat(30)
    static let QUEUE_PLAYER_BUTTONS_PADDING = CGFloat(70)
    static let QUEUE_PLAYER_BUTTONS_SPACING = CGFloat(60)
}
