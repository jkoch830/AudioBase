//
//  FirebaseStorage.swift
//  AudioBase
//
//  Created by James Koch on 8/2/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import FirebaseStorage
import Alamofire


func fireNewMP3ToStorage(youtubeURL: String, title: String, artist: String,
                         taskContainer: DownloadTaskContainer) {
    // Hit cloud function endpoint
    let baseURL: String = "https://youtube-download-xff4umn4va-uc.a.run.app/download"
    let formattedTitle = songNameToFilename(songName: title)
    var url: String = "\(baseURL)?url=\(youtubeURL)&title=\(formattedTitle)"
    url = url.replacingOccurrences(of: "://m.you", with: "://you")
    let newTask = DownloadTaskWrapper(title)
    taskContainer.addDownloadTask(newTask)
    AF.request(url).response { response in
        if response.response?.statusCode == 200 {
            print("REQUEST SUCCESSFUL")
            downloadMP3FromStorage(youtubeURL: youtubeURL, filename: title, artist: artist,
                                   downloadTaskWrapper: newTask)
        } else {
            newTask.failure = true
            print("ERROR WITH REQUEST ", response.response!.statusCode)
        }
    }
}

/// Downloads the file from the 'downloads/' directory within Cloud Storage
/// - Parameter filename: The name of the MP3 file stored within the 'downloads/' directory within Cloud Storage
/// - Parameter youtubeURL: The URL of the youtube video
/// - Parameter artist: The artist of the song
/// - Parameter downloadTaskWrapper: The download task wrapper that will encapsulate the Storage download task
/// - Returns: An optional URL to the new local mp3 file
func downloadMP3FromStorage(youtubeURL: String, filename: String, artist: String,
                            downloadTaskWrapper: DownloadTaskWrapper) {
    let formattedFilename = songNameToFilename(songName: filename)
    let storage = Storage.storage()
    let mp3Ref = storage.reference().child("downloads/\(formattedFilename).mp3")
    let localURL = getAudioDirectory(audioFilename: "\(formattedFilename).mp3")
    downloadTaskWrapper.startDownloadTask(
        mp3Ref.write(toFile: localURL) { url, error in
            if let error = error {
                print(error)
            } else {
                mp3Ref.delete()
                addAudioInfo(AudioInfo(title: filename, artist: artist, youtubeURL: youtubeURL))
            }
        }
    )
}
