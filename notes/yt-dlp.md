## youtube-dl
* * *
### Extract link as audio
```shell
youtube-dl -o "%(title)s-%(id)s.%(ext)s" --audio-format m4a --audio-quality 0 --extract-audio "YOUTUBE_URL"
```