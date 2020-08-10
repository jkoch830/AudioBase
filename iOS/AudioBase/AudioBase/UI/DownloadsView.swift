//
//  DownloadsView.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import FirebaseStorage

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct DownloadTaskRow: View {
    @ObservedObject var downloadTask: DownloadTaskWrapper
    
    func getStatusString() -> String {
        if self.downloadTask.complete {
            return "\(downloadTask.title): Complete"
        } else if downloadTask.failure {
            return "\(downloadTask.title): Failed"
        } else {
            return "\(downloadTask.title): \(downloadTask.progress.rounded(toPlaces: 2))"
        }
    }
    
    var body: some View {
        Text(self.getStatusString())
    }
}


struct DownloadsView: View {
    @EnvironmentObject var audioFileManager: AudioFileManager
    @ObservedObject var taskContainer: DownloadTaskContainer
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(self.taskContainer.getDownloadTasks(), id: \.self.title) { task in
                        DownloadTaskRow(downloadTask: task)
                    }
                }
            }.navigationBarTitle("Active Downloads")
                .navigationBarItems(trailing: Button(action: {
                    self.taskContainer.clear()
                }) {
                    Text("Clear")
                })
        }.padding(.top, 10)
    }
}

