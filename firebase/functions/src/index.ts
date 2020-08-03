import * as functions from 'firebase-functions';
import * as ytdl from 'ytdl-core'
import * as ffmpeg from 'fluent-ffmpeg'
import * as ffmpeg_static from 'ffmpeg-static'
import * as path from 'path'
import * as os from 'os'
import * as admin from 'firebase-admin'

admin.initializeApp()
var bucket = admin.storage().bucket()

// Makes an ffmpeg command return a promise.
function promisifyCommand(command: ffmpeg.FfmpegCommand) {
    return new Promise((resolve, reject) => {
        command.on('end', resolve).on('error', reject).run();
    });
}

/**
 * Takes a URL from a youtube video, downloads the mp4 file, converts it to an
 * mp3 file, then uploads it to Firebase Storage
 */
export const urlToMP3 = functions.https.onRequest(async (request, response) => {
    const url = <string> request.query.url;
    const title = <string> request.query.title;
    const artist = <string> request.query.artist;
    const tempFilePath = path.join(os.tmpdir(), title)
    let proc = ffmpeg(ytdl(url))
    .fromFormat('mp4')
    .toFormat('mp3')
    .setFfmpegPath(ffmpeg_static)            
    .output(tempFilePath)
    try {
        await promisifyCommand(proc)
        const custom = {'title': title, 'artist': artist}
        const metadata = {contentType: 'audio/mpeg', metadata: custom}
        await bucket.upload(tempFilePath, {destination: `downloads/${title}.mp3`, 
                                           metadata: metadata})
        response.status(200).end()
    } catch {
        response.status(400).end()
    }
})