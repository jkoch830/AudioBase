//
//  ColorHolder.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct CustomColors {
    static let CUSTOM_BLUE: Color = Color(red: 18 / 255, green: 207 / 255, blue: 202 / 255)
    static let CUSTOM_PURPLE: Color = Color(red: 186 / 255, green: 11 / 255, blue: 224 / 255)
}

class ColorHolder: ObservableObject {
    @Published var selectedColor: Color = CustomColors.CUSTOM_PURPLE
    
    func selected() -> Color {
        return self.selectedColor
    }
    
    func selectColor(color: Color) {
        self.selectedColor = color
    }
}
