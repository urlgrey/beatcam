# beatcam
Processing app to take still images to the beat of an MP3 audio file

Stores still images in the `caps` sub-directory (created automatically).  Stitch them into a movie with FFmpeg:

```shell
ffmpeg -f image2 -i caps/img-%05d.tiff -i data/marcus_kellis_theme.mp3 ~/Desktop/output.mpg
```
