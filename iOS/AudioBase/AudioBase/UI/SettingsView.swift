//
//  SettingsView.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    @State var uploadSuccessful: Bool?
    @State var downloadSuccessful: Bool?
    var body: some View {
        Form {
            // Sync Local to Cloud Button
            Section {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.downloadSuccessful = nil
                        let downloadTask = self.audioFileManager.mergeLocalWithStorage()
                        downloadTask.observe(.success) { snapshot in
                            self.downloadSuccessful = true
                        }
                        downloadTask.observe(.failure) { snapshot in
                            self.downloadSuccessful = false
                        }
                    }) {
                        Text("Merge Local with Cloud")
                    }
                    if downloadSuccessful != nil && downloadSuccessful! {
                        Text("Success").foregroundColor(.green)
                    } else if downloadSuccessful != nil && !downloadSuccessful! {
                        Text("Failure").foregroundColor(.red)
                    }
                }
            }
            // Sync Cloud to Local Button
            Section {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.uploadSuccessful = nil
                        let uploadTask = self.audioFileManager.syncLocalToStorage()
                        uploadTask.observe(.success) { snapshot in
                            self.uploadSuccessful = true
                        }
                        uploadTask.observe(.failure) { snapshot in
                            self.uploadSuccessful = false
                        }
                    }) {
                        Text("Overwrite Cloud with Local")
                    }
                    if uploadSuccessful != nil && uploadSuccessful! {
                        Text("Success").foregroundColor(.green)
                    } else if uploadSuccessful != nil && !uploadSuccessful! {
                        Text("Failure").foregroundColor(.red)
                    }
                }
            }
            Section {
                Button(action: {
                    self.colorHolder.toggle()
                }) {
                    HStack {
                        Text("Change Color")
                        Image(systemName: "eyedropper.full")
                    }
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
