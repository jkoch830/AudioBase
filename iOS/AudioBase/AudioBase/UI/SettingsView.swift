//
//  SettingsView.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            // Sync Button
            Section {
                Button(action: {
                    print("Syncing")
                }) {
                    Text("Sync With Firebase Storage")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
