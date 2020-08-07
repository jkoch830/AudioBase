//
//  DownloadTaskWrapper.swift
//  AudioBase
//
//  Created by James Koch on 8/6/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import FirebaseStorage

class DownloadTaskWrapper: ObservableObject, Hashable {
    
    @Published var progress: Double
    @Published var complete: Bool
    @Published var failure: Bool
    private var storageDownloadTask: StorageDownloadTask!
    var title: String
    
    init(_ title: String) {
        self.title = title
        self.progress = 0
        self.complete = false
        self.failure = false
    }
    
    func startDownloadTask(_ downloadTask: StorageDownloadTask) {
        self.storageDownloadTask = downloadTask
        self.addObservers()
    }
    
    func addObservers() {
        // Download reported progress
        self.storageDownloadTask.observe(.progress) { snapshot in
            self.progress = 100.0 * Double(snapshot.progress!.completedUnitCount)
              / Double(snapshot.progress!.totalUnitCount)
        }
        // Success
        self.storageDownloadTask.observe(.success) { snapshot in
            self.complete = true
        }
        self.storageDownloadTask.observe(.failure) {snapshot in
            self.failure = true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.storageDownloadTask)
        hasher.combine(self.progress)
    }
    
    static func == (lhs: DownloadTaskWrapper, rhs: DownloadTaskWrapper) -> Bool {
        return lhs.storageDownloadTask == rhs.storageDownloadTask
    }
}
