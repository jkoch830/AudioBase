//
//  FileDirectory.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//
import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getAudioFilesJSONURL() -> URL {
    return getDocumentsDirectory().appendingPathComponent("audioFiles.json")
}

func getAudioDirectory(audioFilename: String) -> URL {
    let documentsURL: URL = getDocumentsDirectory()
    return documentsURL.appendingPathComponent("audio/\(audioFilename)")
}


