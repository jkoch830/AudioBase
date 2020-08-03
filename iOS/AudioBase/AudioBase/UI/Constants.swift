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
    // Songs View
    static let SONGS_BUTTONS_WIDTH = Constants.DEVICE_WIDTH * 5 / 12
    static let SONGS_BUTTONS_HEIGHT = Constants.DEVICE_HEIGHT / 16
    static let SONGS_BUTTONS_CORNER_RADIUS = CGFloat(10)
    static let SONG_ROW_HEIGHT = Constants.DEVICE_HEIGHT / 10
    
}
