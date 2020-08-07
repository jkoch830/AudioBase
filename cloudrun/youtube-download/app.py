import subprocess
from flask import Flask, request
from http import HTTPStatus

import firebase_admin
from firebase_admin import storage

app = Flask(__name__)
firebase_admin.initialize_app()
bucket = storage.bucket("audiobase-2e69b.appspot.com")


def error_response(error_msg: str, code: int):
    """
    Helper function for returning a response with an error
    :param error_msg: The error message
    :param code: The HTTP status code
    :return: A flask response
    """
    return {'error': error_msg}, code


@app.route('/download', methods=['GET'])
def download_and_convert():
    if 'url' not in request.args:
        return error_response("request args must contain 'url'",
                              HTTPStatus.BAD_REQUEST)
    elif 'title' not in request.args:
        return error_response("request args must contain 'title'",
                              HTTPStatus.BAD_REQUEST)
    url: str = request.args['url']
    title: str = request.args['title']
    command: str = f"youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' " \
                   f"--output './tmp/{title}.mp4' '{url}'"
    download_process = subprocess.run(command,
                                      shell=True,
                                      stdout=subprocess.PIPE,
                                      universal_newlines=True)
    command = f"ffmpeg -i ./tmp/{title}.mp4 ./tmp/{title}.mp3"
    convert_process = subprocess.run(command,
                                     shell=True,
                                     stdout=subprocess.PIPE,
                                     universal_newlines=True)
    blob = bucket.blob(f"downloads/{title}.mp3")
    blob.upload_from_filename(f"./tmp/{title}.mp3")
    command = f"rm ./tmp/{title}.*"
    delete_process = subprocess.run(command,
                                    shell=True,
                                    stdout=subprocess.PIPE,
                                    universal_newlines=True)
    return "ok", HTTPStatus.OK

