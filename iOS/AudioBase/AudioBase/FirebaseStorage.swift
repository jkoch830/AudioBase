//
//  FirebaseStorage.swift
//  AudioBase
//
//  Created by James Koch on 8/2/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import FirebaseStorage

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getAudioDirectory(audioFilename: String) -> URL {
    let documentsURL: URL = getDocumentsDirectory()
    return documentsURL.appendingPathComponent("audio/\(audioFilename)")
}

/// Downloads the file from the 'downloads/' directory within Cloud Storage
/// - Parameter filename: The name of the MP3 file stored within the 'downloads/' directory within Cloud Storage
/// - Returns: An optional URL to the new local mp3 file
func downloadMP3FromStorage(filename: String) -> StorageDownloadTask {
    let storage = Storage.storage()
    let mp3Ref = storage.reference().child("downloads/\(filename)")
    let localURL = getAudioDirectory(audioFilename: filename)
    return mp3Ref.write(toFile: localURL)
}


