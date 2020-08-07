//
//  DownloadsView.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct DownloadsView: View {
    @EnvironmentObject var downloadTaskContainer: DownloadTaskContainer
    
    func getStatusString(task: DownloadTaskWrapper) -> String {
        if task.complete {
            return "\(task.title): Complete"
        } else if task.failure {
            return "\(task.title): Failed"
        } else {
            return "\(task.title): \(task.progress)"
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(self.downloadTaskContainer.getDownloadTasks(), id: \.self) { task in
                        Text(self.getStatusString(task: task))
                    }
                }
            }.navigationBarTitle("Active Downloads")
        }.padding(.top, 10)
    }
}

struct DownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsView()
    }
}
