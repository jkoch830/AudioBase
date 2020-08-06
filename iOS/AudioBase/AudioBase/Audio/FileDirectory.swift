//
//  FileDirectory.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//
import Foundation

func songNameToFilename(songName: String) -> String {
    var formatted = songName.replacingOccurrences(of: "\'", with: ";")
    formatted = formatted.replacingOccurrences(of: " ", with: "_")
    return formatted
}

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

func getAllMP3Files() -> [String] {
    do {
        // Get the directory contents urls (including subfolders urls)
        let dir: URL = getDocumentsDirectory().appendingPathComponent("audio/")
        let directoryContents = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
        // if you want to filter the directory contents you can do like this:
        let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
        let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
        return mp3FileNames
    } catch {
        print(error)
        return []
    }
}


