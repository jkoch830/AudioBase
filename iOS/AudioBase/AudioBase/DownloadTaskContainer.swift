//
//  DownloadTaskContainer.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import FirebaseStorage


class DownloadTaskContainer: ObservableObject {
    @Published var downloadTasks = [DownloadTaskWrapper]()
    
    func addDownloadTask(_ task: DownloadTaskWrapper) {
        downloadTasks.append(task)
        
    }
    
    func getDownloadTasks() -> [DownloadTaskWrapper] {
        return self.downloadTasks
    }
}
