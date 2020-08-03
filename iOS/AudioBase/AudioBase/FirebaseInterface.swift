//
//  FirebaseStorage.swift
//  AudioBase
//
//  Created by James Koch on 8/2/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import FirebaseStorage
import Alamofire



func fireNewMP3ToStorage(youtubeURL: String, title: String, artist: String) {
    // Hit cloud function endpoint
    let baseURL: String = "https://us-central1-audiobase-2e69b.cloudfunctions.net/urlToMP3"
    let url: String = "\(baseURL)?url=\(youtubeURL)&title=\(title)"
    AF.request(url).response { response in
        if response.response?.statusCode == 200 {
            print("REQUEST SUCCESSFUL")
            downloadMP3FromStorage(filename: title, artist: artist)
        } else {
            print("ERROR WITH REQUEST: ", response.response?.statusCode)
        }
    }
}

/// Downloads the file from the 'downloads/' directory within Cloud Storage
/// - Parameter filename: The name of the MP3 file stored within the 'downloads/' directory within Cloud Storage
/// - Returns: An optional URL to the new local mp3 file
func downloadMP3FromStorage(filename: String, artist: String) {
    let storage = Storage.storage()
    let mp3Ref = storage.reference().child("downloads/\(filename).mp3")
    let localURL = getAudioDirectory(audioFilename: "\(filename).mp3")
    mp3Ref.write(toFile: localURL) { url, error in
        if let error = error {
            print(error)
        } else {
            mp3Ref.delete()
            addAudioInfo(AudioInfo(title: filename, artist: artist, fileURL: url!))
        }
    }
}
