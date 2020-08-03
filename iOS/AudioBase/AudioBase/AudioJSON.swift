//
//  AudioFileJSON.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation

struct AudioInfo: Codable {
    let title: String
    let artist: String
    let fileURL: URL
}


struct Playlist: Codable {
    let playlistTitle: String
    let songTitles: [String]
}

/// Checks that the audio JSON file exists. If it doesn't exist or if it's empty, an empty dictionary is initialized
func verifyAudioFileExists() {
    let url = getAudioFilesJSONURL()
    do {
        // Check that file exists
        if !FileManager.default.fileExists(atPath: url.path) {
            try "{}".write(to: url, atomically: true, encoding: .utf8)
        }
        // Check that a dictionary exists
        let currentData: Data = try Data(contentsOf: url)
        if currentData.count < 2 {
            try "{}".write(to: url, atomically: true, encoding: .utf8)
        }
    } catch {
        print(error)
    }
}

func addAudioInfo(newAudioInfo: AudioInfo) {
    verifyAudioFileExists()
    let url = getAudioFilesJSONURL()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    encoder.outputFormatting = [.prettyPrinted]
    do {
        // Retrieve current JSON data, convert to dictionary, then update new AudioInfo
        if !FileManager.default.fileExists(atPath: url.path) {
            try "{}".write(to: url, atomically: true, encoding: .utf8)
        }
        let currentData: Data = try Data(contentsOf: url)
        var currentJSONData = try decoder.decode([String: AudioInfo].self, from: currentData)
        currentJSONData[newAudioInfo.title] = newAudioInfo
        // Convert updated array to JSON data, then write to file
        let newData: Data = try encoder.encode(currentJSONData)
        let newJSONString = String(data: newData, encoding: .utf8)!
        try newJSONString.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}

func getAudioInfo(title: String) -> AudioInfo? {
    verifyAudioFileExists()
    let url = getAudioFilesJSONURL()
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([String: AudioInfo].self, from: data)
        return jsonData[title]
    } catch {
        print("error:\(error)")
        return nil
    }
}


