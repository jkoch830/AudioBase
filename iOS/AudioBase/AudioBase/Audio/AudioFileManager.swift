//
//  AudioFileInterface.swift
//  AudioBase
//
//  Created by James Koch on 8/10/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import Foundation
import Combine
import FirebaseStorage
import Alamofire

struct AudioInfo: Codable, Hashable {
    var title: String
    var artist: String
    let youtubeURL: String
}


struct Playlist: Codable, Hashable {
    var playlistTitle: String
    var songTitles: [String]
}


final class AudioFileManager: ObservableObject {
    @Published var allAudioInfo: [String: AudioInfo]!
    @Published var playlists: [String: Playlist]!
    var downloadTaskContainer: DownloadTaskContainer = DownloadTaskContainer()
    
    init() {
        self.verifyJSONFileExists(url: getAudioInfoURL())
        self.verifyJSONFileExists(url: getPlaylistURL())
        self.allAudioInfo = self.getAllAudioInfo()
        self.playlists = self.getPlaylists()
    }
}
    
extension AudioFileManager {
    
    func clearDownloads() {
        self.downloadTaskContainer.clear()
    }
    
    func addAudioInfo(title: String, artist: String, youtubeURL: String) {
        let newAudioInfo = AudioInfo(title: title, artist: artist, youtubeURL: youtubeURL)
        self.allAudioInfo[newAudioInfo.title] = newAudioInfo
        overwriteAudioInfo(newAudioInfoJSON: self.allAudioInfo)
    }
    
    func deleteAudioInfo(title: String) {
        self.allAudioInfo.removeValue(forKey: title)
        self.overwriteAudioInfo(newAudioInfoJSON: self.allAudioInfo)
        let filename = songNameToFilename(songName: title)
        try? FileManager.default.removeItem(at: getAudioFileURL(audioFilename: filename))
        self.deleteSongFromAllPlaylists(songTitle: title)
    }
    
    func getAudioInfo(title: String) -> AudioInfo? {
        return self.allAudioInfo[title]
    }
    
    /// Retrieves the entire JSON dictionary from the audioFiles.json file
    /// - Returns: The entire JSON dictionary
    func getAllAudioInfo() -> [String: AudioInfo] {
        let url = getAudioInfoURL()
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try! decoder.decode([String: AudioInfo].self, from: data)
    }
    
    /// Retrieves all audio info in an arraay
    /// - Parameter sortByTitle: Indicates if array is sorted by title or by artist
    /// - Returns: The array of all audio info
    func getSortedAudioInfo(sortByTitle: Bool) -> [AudioInfo] {
        let infoArray: [AudioInfo] = Array(getAllAudioInfo().values)
        if sortByTitle {
            return infoArray.sorted { $0.title < $1.title }
        } else {
            return infoArray.sorted { $0.artist < $1.artist }
        }
    }
    
    func downloadNewAudio(youtubeURL: String, title: String, artist: String) {
        self.downloadYoutubeToStorage(youtubeURL: youtubeURL, title: title, artist: artist)
    }
}

// Playlist functionality
extension AudioFileManager {
    func getPlaylists() -> [String: Playlist] {
        let url = getPlaylistURL()
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try! decoder.decode([String: Playlist].self, from: data)
    }
    
    func addPlaylist(title: String, songs: [String]) {
        let newPlaylist = Playlist(playlistTitle: title, songTitles: songs)
        self.playlists[title] = newPlaylist
        self.overwritePlaylistInfo(newPlaylistJSON: self.playlists)
    }
    
    func getSortedPlaylists() -> [Playlist] {
        return Array(self.getPlaylists().values)
    }
    
    func deletePlaylist(title: String) {
        self.playlists.removeValue(forKey: title)
        self.overwritePlaylistInfo(newPlaylistJSON: self.playlists)
    }
    
    func updatePlaylist(oldTitle: String, newTitle: String, newPlaylist: Playlist) {
        if oldTitle != newTitle {
            self.playlists.removeValue(forKey: oldTitle)
        }
        self.playlists[newTitle] = newPlaylist
        self.overwritePlaylistInfo(newPlaylistJSON: self.playlists)
    }
    
    func deleteSongFromAllPlaylists(songTitle: String) {
        let playlistsCopy = self.playlists!
        for (playlistTitle, playlist) in playlistsCopy {
            var newPlaylist = playlist
            newPlaylist.songTitles.removeAll(where: { $0 == songTitle })
            self.playlists[playlistTitle] = newPlaylist
        }
        overwritePlaylistInfo(newPlaylistJSON: self.playlists)
    }
    
    
}

// Firebase methods
extension AudioFileManager {
    /// Replaces all saved data in Firebase Storage with the current, local data
    /// - Returns: The upload task
    func syncLocalToStorage() -> StorageUploadTask {
        let audioInfoURL = getAudioInfoURL()
        let audioInfoRef = Storage.storage().reference().child(getAudioInfoRefPath())
        return audioInfoRef.putFile(from: audioInfoURL, metadata: nil)
    }

    /// Merges the current, local data with the saved data in Firebase storage
    /// - Returns: The download task
    func mergeLocalWithStorage() -> StorageDownloadTask {
        let audioInfoRef = Storage.storage().reference().child(getAudioInfoRefPath())
        return audioInfoRef.getData(maxSize: 1 * 1024 * 1024) { data, _ in
            let decoder = JSONDecoder()
            let cloudData = try! decoder.decode([String: AudioInfo].self, from: data!)
            
            self.allAudioInfo.merge(cloudData) { (current, _) in current }
            self.overwriteAudioInfo(newAudioInfoJSON: self.allAudioInfo)
            
            // Download all missing audio files
            for (title, audioInfo) in self.allAudioInfo {
                if !audioFileExists(songName: title) {
                    self.downloadNewAudio(youtubeURL: audioInfo.youtubeURL, title: title,
                                          artist: audioInfo.artist)
                }
                
            }
        }
    }
    
    private func downloadYoutubeToStorage(youtubeURL: String, title: String, artist: String) {
        // Hit cloud function endpoint
        let baseURL: String = "https://youtube-download-xff4umn4va-uc.a.run.app/download"
        var filename = songNameToFilename(songName: title)
        filename.removeLast(4)   // Remove '.mp3'
        var url: String = "\(baseURL)?url=\(youtubeURL)&title=\(filename)"
        url = url.replacingOccurrences(of: "://m.you", with: "://you")
        let newTask = DownloadTaskWrapper(title)
        self.downloadTaskContainer.addDownloadTask(newTask)
        AF.request(url).response { response in
            if response.response?.statusCode == 200 {
                print("REQUEST SUCCESSFUL")
                newTask.startDownloadTask(
                    self.downloadMP3FromStorage(youtubeURL: youtubeURL, title: title,
                                                artist: artist)
                )
            } else {
                newTask.failure = true
            }
        }
    }

    /// Downloads the file from the 'downloads/' directory within Cloud Storage
    /// - Parameter filename: The name of the MP3 file stored within the 'downloads/' directory within Cloud Storage
    /// - Parameter youtubeURL: The URL of the youtube video
    /// - Parameter artist: The artist of the song
    /// - Returns: The download task
    private func downloadMP3FromStorage(youtubeURL: String, title: String,
                                artist: String) -> StorageDownloadTask {
        let storage = Storage.storage()
        let filename = songNameToFilename(songName: title)
        let mp3Ref = storage.reference().child("downloads/\(filename)")
        let localURL = getAudioFileURL(audioFilename: filename)
        return mp3Ref.write(toFile: localURL) { url, error in
            if let error = error {
                print(error)
            } else {
                mp3Ref.delete()
                self.addAudioInfo(title: title, artist: artist, youtubeURL: youtubeURL)
            }
        }
    }
}


fileprivate extension AudioFileManager {
    
    func getAudioInfoRefPath() -> String {
        return "audioInfo.json"
    }
    
    func overwritePlaylistInfo(newPlaylistJSON: [String: Playlist]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let newData: Data = try! encoder.encode(newPlaylistJSON)
        let newJSONString = String(data: newData, encoding: .utf8)!
        try! newJSONString.write(to: getPlaylistURL(), atomically: true, encoding: .utf8)
    }
    
    /// Overwrites the audioInfoJSON file with new daata
    /// - Parameter newAudioInfoJSON: The new JSON information that is being used to overwrite the current data
    /// - Throws: Error if writing to file fails
    func overwriteAudioInfo(newAudioInfoJSON: [String: AudioInfo]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let newData: Data = try! encoder.encode(newAudioInfoJSON)
        let newJSONString = String(data: newData, encoding: .utf8)!
        try! newJSONString.write(to: getAudioInfoURL(), atomically: true, encoding: .utf8)
    }
    
    func verifyJSONFileExists(url : URL) {
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
}
