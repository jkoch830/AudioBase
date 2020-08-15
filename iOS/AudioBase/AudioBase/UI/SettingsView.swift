//
//  SettingsView.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct SettingsView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    @EnvironmentObject var colorHolder: ColorHolder
    @State var playlistsUploadSuccessful: Bool?
    @State var audioInfoUploadSuccessful: Bool?
    @State var playlistsDownloadSuccessful: Bool?
    @State var audioInfoDownloadSuccessful: Bool?
    
    func taskSuccessful(task1: Bool?, task2: Bool?) -> Bool? {
        if (task1 != nil && !task1!) || (task2 != nil && !task2!) {
            return false
        } else if task1 != nil && task1! && task2 != nil && task2! {
            return true
        } else {
            return nil
        }
    }
    
    func addUploadObservers(audioInfoTask: StorageUploadTask, playlistsTask: StorageUploadTask) {
        audioInfoTask.observe(.success) { snapshot in
            self.audioInfoUploadSuccessful = true
        }
        audioInfoTask.observe(.failure) { snapshot in
            self.audioInfoUploadSuccessful = false
        }
        playlistsTask.observe(.success) { snapshot in
            self.playlistsUploadSuccessful = true
        }
        playlistsTask.observe(.failure) { snapshot in
            self.playlistsUploadSuccessful = false
        }
    }
    
    func addDownloadObservers(audioInfoTask: StorageDownloadTask,
                              playlistsTask: StorageDownloadTask) {
        audioInfoTask.observe(.success) { snapshot in
            self.audioInfoDownloadSuccessful = true
        }
        audioInfoTask.observe(.failure) { snapshot in
            self.audioInfoDownloadSuccessful = false
        }
        playlistsTask.observe(.success) { snapshot in
            self.playlistsDownloadSuccessful = true
        }
        playlistsTask.observe(.failure) { snapshot in
            self.playlistsDownloadSuccessful = false
        }
    }
     
    var body: some View {
        Form {
            // Sync Local to Cloud Button
            Section {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.audioInfoDownloadSuccessful = nil
                        self.playlistsDownloadSuccessful = nil
                        let downloadTasks = self.audioFileManager.mergeLocalWithStorage()
                        self.addDownloadObservers(audioInfoTask: downloadTasks[0],
                                                  playlistsTask: downloadTasks[1])
                    }) {
                        Text("Merge Local with Cloud")
                    }
                    if self.taskSuccessful(task1: audioInfoDownloadSuccessful,
                                           task2: playlistsDownloadSuccessful) != nil {
                        if self.taskSuccessful(task1: audioInfoDownloadSuccessful,
                                               task2: playlistsDownloadSuccessful)! {
                            Text("Success").foregroundColor(.green)
                        } else {
                            Text("Failure").foregroundColor(.red)
                        }
                    }
                }
            }
            // Sync Cloud to Local Button
            Section {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.audioInfoUploadSuccessful = nil
                        self.playlistsUploadSuccessful = nil
                        let uploadTasks = self.audioFileManager.syncLocalToStorage()
                        self.addUploadObservers(audioInfoTask: uploadTasks[0],
                                                playlistsTask: uploadTasks[1])
                    }) {
                        Text("Overwrite Cloud with Local")
                    }
                    if self.taskSuccessful(task1: audioInfoUploadSuccessful,
                                           task2: playlistsUploadSuccessful) != nil {
                        if self.taskSuccessful(task1: audioInfoUploadSuccessful,
                                               task2: playlistsUploadSuccessful)! {
                            Text("Success").foregroundColor(.green)
                        } else {
                            Text("Failure").foregroundColor(.red)
                        }
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
