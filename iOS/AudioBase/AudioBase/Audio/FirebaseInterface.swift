//
//  FirebaseStorage.swift
//  AudioBase
//
//  Created by James Koch on 8/2/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import FirebaseStorage
import Alamofire

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

func fireNewMP3ToStorage(youtubeURL: String, title: String, artist: String) {
    // Hit cloud function endpoint
    let baseURL: String = "https://us-central1-audiobase-2e69b.cloudfunctions.net/urlToMP3"
    let formattedTitle = songNameToFilename(songName: title)
    var url: String = "\(baseURL)?url=\(youtubeURL)&title=\(formattedTitle)"
    url = url.replacingOccurrences(of: "://m.you", with: "://you")
    AF.request(url).response { response in
        if response.response?.statusCode == 200 {
            print("REQUEST SUCCESSFUL")
            downloadMP3FromStorage(filename: title, artist: artist)
        } else {
            print("ERROR WITH REQUEST ", response.response?.statusCode)
        }
    }
}

/// Downloads the file from the 'downloads/' directory within Cloud Storage
/// - Parameter filename: The name of the MP3 file stored within the 'downloads/' directory within Cloud Storage
/// - Returns: An optional URL to the new local mp3 file
func downloadMP3FromStorage(filename: String, artist: String) {
    let formattedFilename = songNameToFilename(songName: filename)
    let storage = Storage.storage()
    let mp3Ref = storage.reference().child("downloads/\(formattedFilename).mp3")
    let localURL = getAudioDirectory(audioFilename: "\(formattedFilename).mp3")
    mp3Ref.write(toFile: localURL) { url, error in
        if let error = error {
            print(error)
        } else {
            mp3Ref.delete()
            addAudioInfo(AudioInfo(title: filename, artist: artist, fileURL: url!))
        }
    }
}

func tempFunction() {
    let storage = Storage.storage()
    let mp3Ref = storage.reference().child("downloads/lucky.mp4")
    let localURL = getAudioDirectory(audioFilename: "lucky.mp4")
    print("ATTEMPTING TO WRITE")
    mp3Ref.write(toFile: localURL) { url, error in
        if let error = error {
            print(error)
        } else {
            print("SUCCESS DOWNLOADING LUCKY")
        }
        
    }
}
