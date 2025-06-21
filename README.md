# FFmpeg: A short guide

FFmpeg is a cross-platform command line tool to record, convert and stream audio and video. The software is free, open-source and much more versatile than most proptietary software (such as Adobe Media Encoder). If you use Linux, simply install FFmpeg via `apt-get install ffmpeg`. If you are using MacOS you can easily install ffmpeg via Homebrew or [MacPorts](https://github.com/term7/01_MacPorts-Installer):


`brew install ffmpeg`<br>
`sudo port install ffmpeg`

This gist covers only a few use cases and commands for FFmpeg.
We use them quite frequently. For the official documentation, please visit:

[https://ffmpeg.org/documentation.html](https://ffmpeg.org/documentation.html)

## BASIC AND ADVANCED USAGE

- [01 - List supported Codecs and Formats](#01---List-supported-Codecs-and-Formats)
- [02 - Simple file conversion](#02---simple-file-conversion)
- [03 - Extract or convert either audio or video](#03---Extract-or-convert-either-audio-or-video)
- [04 - High quality conversion Apple-proRes4444 to H264](#04---High-quality-conversion-Apple-proRes4444-to-H264)
- [05 - Bitrate presets to reduce file size for Vimeo or Youtube](#05---Bitrate-presets-to-reduce-file-size-for-Vimeo-or-Youtube)
- [06 - Reduce file size by manipulating CRF](#06---Reduce-file-size-by-manipulating-CRF)
- [07 - Trim Video](#07---Trim-Video)
- [08 - Use Filters](#08---Use-Filters)
- [09 - Replace Audio](#09---Replace-Audio)
- [10 - Mix Audio Channels](#10---Mix-Audio-Channels)
- [11 - Surround Sound](#11---Surround-Sound)
- [12 - Merge multiple videos for example to create a seamless playlist](#12---Merge-multiple-videos-for-example-to-create-a-seamless-playlist)
- [13 - Batch Conversion - Encode Multiple Files](#13---Batch-Conversion---Encode-Multiple-Files)
- [14 - Convert video frames into video stills](#14---Convert-video-frames-into-video-stills)
- [15 - Convert images into a video](#15---Convert-images-into-a-video)
- [16 - Create a slideshow from images](#16---Create-a-slideshow-from-images)
- [17 - Animated GIF from images](#17---Animated-GIF-from-images)

## SPECIFIC USE CASES

- [18 - Package a DVD into MKV](#18---Package-a-DVD-into-MKV)
- [19 - Convert your entire Apple Music Library from M4A to MP3](#19---Convert-your-entire-Apple-Music-Library-from-M4A-to-MP3)

---

# BASIC AND ADVANCED USAGE

# 01 - List supported Codecs and Formats
 
Command to list supported formats:<br>
`ffmpeg -formats`

Command to list installed codecs:<br>
`ffmpeg -codecs`
 
 
 
# 02 - Simple file conversion
 
 Convert input audio or video file into another file format, i.e.:
 
`ffmpeg -i input.avi output.mp4`<br>
`ffmpeg -i input.wav output.mp3`

The -i option always specifies the input file (i.e. input.avi), while the last parameter always represents the desired output (i.e. output.mp4). FFmpeg will automatically select the required codec to convert your file, unless you specify codec and conversion options you want to use. You will have to select the codec and specify other options if you want to achieve a specific end result.



# 03 - Extract or convert either audio or video

The main difference between copying and converting audio or video is speed. When transcoding your computer uses quite a lot of CPU, while when copying it simply moves bytes from one file to another.

To extract audio you have to specify that you don't want to encode video (-vn), but copy audio (-codec:a copy):<br>
`ffmpeg -i input.mp4 -vn -codec:a copy output.aac`

You can also convert the audio (-codec:a aac) without the video stream (-vn):<br>
`ffmpeg -i input.mov -vn -codec:a aac output.aac`

To extract the video you have to specify that you don't want to encode audio (-an), but copy the video stream (-v:codec copy):<br>
`ffmpeg -i input.mp4 -codec:v copy -an output.mp4`

You can also convert a *.mov video file into H264.mp4 (-codec:v libx264) without the audio stream (-an):<br>
`ffmpeg -i input.mov -codec:v libx264 -an output.mp4`



# 04 - High quality conversion Apple-proRes4444 to H264

If you have a huge raw video file, i.e. in Apple-proRes4444, and you want to convert it into a high quality H264.mp4 with AAC audio, you would use this command:

`ffmpeg -i input.mov -codec:v libx264 -pix_fmt yuv420p -b:v 10000k -minrate 9000k -maxrate 32000k -bufsize 9000k -vf scale=1920:1080 -codec:a aac -b:a 320k output.mp4`

In this example we specify that FFmpeg should use H.264 as video codec (-codec:v libx264), with a pixel format of 12bits per pixel and YUV colorspace (-pix_fmt yuv420p). We sspecify a bitrate of 10000k (-b:v 10000k), with a minimum bitrate of 9000k (-minrate 9000k), a maximum bitrate of 32000k (-maxrate 32000k) and a buffersize of 9000k (-bufsize 9000k). Then we tell FFmpeg to export the video in full HD (-vf scale=1920:1080).
Next we define the audio output options. We want to convert the audio codec to be AAC (-codec:a aac) with a bitrate of 320k (-b:a 320k).
Finally we specify, that we want our video to be in an MP4 container (output.mp4).



# 05 - Bitrate presets to reduce file size for Vimeo or Youtube

Examples ofifferent bitrate settings to export the same input into full HD (1080p), HD (720p) or SD (480p):

MP4 - 1080p<br>
`ffmpeg -i input.mov -codec:v libx264 -pix_fmt yuv420p -b:v 10000k -minrate 7000k -maxrate 10000k -bufsize 9000k -vf scale=1920:1080 -codec:a aac -b:a 320k output.mp4`

MP4 - 720p<br>
`ffmpeg -i input.mov -codec:v libx264 -pix_fmt yuv420p -b:v 5000k -minrate 4500k -maxrate 5000k -bufsize 4000k -vf scale=1280:720 -codec:a aac -b:a 320k output.mp4`

MP4 - 480p<br>
`ffmpeg -i input.mov -codec:v libx264 -pix_fmt yuv420p -b:v 2000k -minrate 1500k -maxrate 2000k -bufsize 2000k -vf scale=854:480 -codec:a aac -b:a 320k output.mp4`



# 06 - Reduce file size by manipulating CRF

CRF = Constant Rate Factor.
Both with x264 and x265 you can specifiy values between 0 and 51. A CRF of 0 represents a lossless conversion (-crf 0), while a CRF of 51 (-crf 51) will result in a heavy compression and the lowest quality.

CRF 1:<br>
`ffmpeg -i input.mov -codec:v libx264 -crf 1 output.mp4`

This setting converted a 13.8GB (Apple-proRES.mov) to a 7.1GB (H264.mp4).

CRF 25:<br>
`ffmpeg -i input.mov -codec:v libx264 -crf 25 output.mp4`

This setting reduced a 13.8GB file (Apple-proRES.mov) to a 128.3MB file (H264.mp4). The video quality is still acceptible.

CRF 25 + grayscale:<br>
`ffmpeg -i input.mov -vf eq=saturation=0 -codec:v libx264 -crf 25 output.mp4`

This setting reduced a 13.8GB file (Apple-proRES.mov) to a 114.9MB file (H264.mp4).



# 07 - Trim Video

Suppose you want to remove the first 30 seconds from the beginning of a 5min video and save a file that is only 2min long:

`ffmpeg -i input.mp4 -ss 00:00:30 -t 00:02:00 -async 1 -strict -2 output.mp4`



# 08 - Use Filters


There are a lot of filters that you can use. In this guide we already used a few filters, i.e.: -vf scale=854:480 or -vf eq=saturation=0

But filters can also be combined. In this example we change the scale of the video, its size, brightness and saturation:

`ffmpeg -i input.mov -vf scale=854:480,eq=brightness=-0.1:saturation=1.5 output.mp4 `

Other possible options are: gamma and contrast (just to name some examples).
Here a link to the official documantation: [https://ffmpeg.org/ffmpeg-filters.html](https://ffmpeg.org/ffmpeg-filters.html) 

The following filter setting can be used to create a smooth fade-in and fade-out effect. The fade-in effect happens at the beginning of the video and is 2 seconds long (fade=in:0:d2). In this example we know that our video is 5min (300sec) long and that our video has 25 frames per second. This means our video has 25 x 300 = 7500 frames. We want to add a slightly slower fade-out effect, which is supposed to be 3 seconds long at the very end of our video. Thus we have to set our filter to finish at frame 7500 (fade=out:7500:d=3):

`ffmpeg -i input.mov -vf fade=in:0:d=2,fade=out:7500:d=3 output.mp4 `




# 09 - Replace Audio

Suppose you have two different video files. You want to use the video stream of file_1.mp4 and combine it with the audio of file_2.mp4:

`ffmpeg -i file_1.mp4 -i file_2.mp4 -map 0:v -map 1:a -c copy combined_output.mp4`



# 10 - Mix Audio Channels

Left channel to mono:<br>
`ffmpeg -i input.mp4 -map_channel 0.1.0 -c:v copy mono.mp4`

Right channel to mono:<br>
`ffmpeg -i input.mp4 -map_channel 0.1.1 -c:v copy mono.mp4`

Left channel to stereo:<br>
`ffmpeg -i input.mp4 -map_channel 0.1.0 -map_channel 0.1.0 -c:v copy stereo.mp4`

Right channel to stereo:<br>
`ffmpeg -i input.mp4 -map_channel 0.1.1 -map_channel 0.1.1 -c:v copy stereo.mp4`



# 11 - Surround Sound

Encode 5.1 surround sound from 6 separate mono files:

`ffmpeg -i front_left.wav -i front_right.wav -i front_center.wav -i lfe.wav -i surround_left.wav -i surround_right.wav -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a]join=inputs=6:channel_layout=5.1:map=0.0-FL|1.0-FR|2.0-FC|3.0-LFE|4.0-BL|5.0-BR[a]" -map "[a]" surround.wav`

Encode video as high quality MKV with Dolby Digital 5.1 Surround Audio:

`ffmpeg -i input.mov -i surround.wav -map 0:v -map 1:a -codec:v libx264 -pix_fmt yuv420p -b:v 10000k -minrate 7000k -maxrate 10000k -bufsize 9000k -vf scale=1920:1080 -codec:a ac3 -ac 6 -ar 48000 -b:a 320k output.mkv`

Encode video as high quality MKV with LinearPCM 5.1 Surround Audio:

`ffmpeg -i input.mov -i surround.wav -map 0:v -map 1:a -codec:v libx264 -pix_fmt yuv420p -b:v 10000k -minrate 7000k -maxrate 10000k -bufsize 9000k -vf scale=1920:1080 -codec:a pcm_s16le -ac 6 -ar 48000 -b:a 320k output.mkv`



# 12 - Merge multiple videos for example to create a seamless playlist

Open a text editor and insert the path to each video file you want to merge (merge.txt).
Use a new line for each entry:

`$ cat merge.txt`<br>
`file '/path/to/file1'`<br>
`file '/path/to/file2'`<br>
`file '/path/to/file3'`<br>
`file '/path/to/...'`

Then use FFmpeg to merge the files:

`ffmpeg -f concat -safe 0 -i merge.txt -c copy output.mp4`



# 13 - Batch Conversion - Encode Multiple Files

Convert i.e. multiple WAV-files into MP3-files (this command only works in the current directory):

`for audio in *.wav; do ffmpeg -i "$audio" -ab 128k -id3v2_version 3 -acodec libmp3lame -vsync 2 "${audio%.wav}.mp3"; done`

To convert all files in a directory and in all subdirecories you can use a combination of the find command, bash and ffmpeg. This example command will create a folder called mp3 in the directory with your WAV-files and in each subdirectory that contains WAV-files. Then it will continue to convert all WAV-files into MP3-files and store them in the respective mp3-directory:

`find /PATH/TO/FOLDER -iname '*.wav' -exec bash -c 'D=$(dirname "{}"); mkdir "$D/mp3"; B=$(basename "{}"); ffmpeg -i "{}" -ab 128k -id3v2_version 3 -acodec libmp3lame -vsync 2 "$D/mp3/${B%.*}.mp3";' \;`



# 14 - Convert video frames into video stills

Convert each frame in low quality:<br>
`ffmpeg -i input.mp4 frame%05d.jpg`

Convert each frame in maximum quality (-q:v 1 -qmin 1):<br>
`ffmpeg -i input.mp4 -q:v 1 -qmin 1 frame%05d.jpg`

Extract a single frame at ~60 seconds duration (-ss 60):<br>
`ffmpeg -ss 60 -i input.mp4 -q:v 1 -qmin 1 -frames:v 1 frame.jpg`



# 15 - Convert images into a video

Convert a single image into H264.mp4 with a duration of 30 seconds (-t 30):

`ffmpeg -loop 1 -i image.png -c:v libx264 -t 30 -pix_fmt yuv420p -vf scale=1920:1080 output.mp4`

Convert all images in a folder into one H264.mp4, each image represents one frame (i.e. progressive 25 frames per second):

`ffmpeg -pattern_type glob -i '*.jpg' -c:v libx264 -framerate 25 -pix_fmt yuv420p output.mp4`



# 16 - Create a slideshow from images

All images in the source folder have the same size and aspect ratio. The video will have a framerate of 25 frames per second (-framerate 25) and each image will be shown for 5 seconds (-r 1/5):

`ffmpeg -r 1/5 -pattern_type glob -i '*.jpg' -c:v libx264 -framerate 25 -pix_fmt yuv420p output.mp4`

All images in the source folder have the same size and aspect ratio. The video will have a framerate of 30 frames per second (-framerate 30) and each image will be shown for 5 seconds (-r 1/3):

`ffmpeg -r 1/3 -pattern_type glob -i '*.jpg' -c:v libx264 -framerate 30 -pix_fmt yuv420p output.mp4`

Images in the source folders have different sizes and aspect ratios and will be shown in a 16:9 slideshow in full HD (1920 x 1080):

`ffmpeg -r 1/5 -pattern_type glob -i '*.jpg' -c:v libx264 -framerate 25 -pix_fmt yuv420p -vf "scale=iw*min(1920/iw\,1080/ih):ih*min(1920/iw\,1080/ih), pad=1920:1080:(1920-iw*min(1920/iw\,1080/ih))/2:(1080-ih*min(1920/iw\,1080/ih))/2" output.mp4`

Images in the source folders have different sizes and aspect ratios and will be shown in a 4:3 slideshow in full HD (1440 x 1080):

`ffmpeg -r 1/5 -pattern_type glob -i '*.jpg' -c:v libx264 -framerate 25 -pix_fmt yuv420p -vf "scale=iw*min(1440/iw\,1080/ih):ih*min(1440/iw\,1080/ih), pad=1440:1080:(1440-iw*min(1440/iw\,1080/ih))/2:(1080-ih*min(1440/iw\,1080/ih))/2" output.mp4`



# 17 - Animated GIF from images

All images in the source folder have the same size and aspect ratio. In this example the images are saved as PNG and each image will be shown for 0.5 seconds (-r 1/0.5):

`ffmpeg -r 1/0.5 -pattern_type glob -i '*.png' out.gif`

---

# SPECIFIC USE CASES



# 18 - Package a DVD into MKV

Copy your DVD to your hard disk and browse to the VIDEO_TS folder:<br>
`cd VIDEO_TS`

Merge all *.VOB files into one file:<br>
`cat *.VOB > output.vob`

Inspect output.vob:<br>
`ffmpeg -analyzeduration 100M -probesize 100M -i output.vob`

FFmpeg might return an output like this:

`Input #0, mpeg, from 'output.vob':`<br>
`  Duration: 00:09:36.51, start: 0.060000, bitrate: 109065 kb/s`<br>
`    Stream #0:0[0x1bf]: Data: dvd_nav_packet`<br>
`    Stream #0:1[0x1e0]: Video: mpeg2video (Main), yuv420p(tv, smpte170m, progressive), 720x576 [SAR 64:45 DAR 16:9], 9000 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc`<br>
`    Side data:`<br>
`      cpb: bitrate max/min/avg: 9000000/0/0 buffer size: 1835008 vbv_delay: N/A`<br>
`    Stream #0:2[0x21]: Subtitle: dvd_subtitle`<br>
`    Stream #0:3[0x20]: Subtitle: dvd_subtitle`<br>
`    Stream #0:4[0x80]: Audio: ac3, 48000 Hz, stereo, fltp, 192 kb/s`

Even though FFmpeg does not show us the language of the subtitles, we can look up the languages of this DVD in its settings. In this example we know that the first language of this DVD is English and we know that there are subtitles in English and in French. Based on all this information, we decide which streams we want to keep:

We want to keep Stream 1, because this stream is the main video.
We also want to keep Stream 4 because it is our English Audio.
Further we want to keep our two Subtitle Streams, in this case Stream 2 and Stream 3.
The DVD navigation menu is useless for us. Thus we discard Stream 0.

This command will package our DVD into a .mkv file:

```
ffmpeg \
  -analyzeduration 100M -probesize 100M \
  -i output.vob \
  -map 0:1 -map 0:2 -map 0:3 -map 0:4 \
  -metadata:s:s:0 language=eng -metadata:s:s:0 title="English" \
  -metadata:s:s:1 language=fre -metadata:s:s:1 title="French" \
  -metadata:s:a:0 language=eng -metadata:s:a:0 title="English stereo" \
  -codec:v libx264 -crf 21 \
  -codec:a libmp3lame -qscale:a 2 \
  -codec:s copy \
  output.mkv
```


# 19 - Convert your entire Apple Music Library from M4A to MP3

When you download Music from the iTunes Store, Apple Music automatically downloads M4A files. Thus we assume you have your entire Apple Music Library stored as M4A. However, many media players still do not support M4A. If you want to listen to your music, i.e. on your Android Device (and your Android Music Player does not support M4A), it can be quite a hassle to convert your Music Library into MP3 and then transfer only the MP3 files to your device.
This script is designed to copy the folder structure of your Music Library and then convert all M4A-files into MP3-files, all stored in a newly created Music Directory on your Desktop or any other location that you specify in this script. You can always change it according to your batch conversion needs.

IMPORTANT: THIS SCRIPT MAKES USE OF SED. SED IN MACOS IS DIFFERENT TO GNUSED AND SED IN LINUX. IF YOU WANT TO USE THIS SCRIPT ON ANOTHER SYSTEM THAN MACOS, PLEASE CHANGE ALL SED COMMANDS ACCORDINGLY. THIS SCRIPT HAS BEEN TESTED ON MACOS BIG SUR. WE SUCCESSFULLY CONVERTED A MUSIC LIBRARY CONSISTING OF 4617 M4A-FILES.

Copy the script below or download the script [here](https://github.com/term7/FFmpeg-A-short-Guide/blob/33666a4054c1e1ae5ddb0c99b9168a3e201aa40a/Script/ffmpeg_batch_converter.sh). To convert your Music Library, simply execute this script - if you want to batch convert i.e. all videos in a folder, change the paramaters in the script accordingly!

```
#!/bin/bash

# Please note: This script makes use of 'sed'. In MacOS 'sed' is slightly different than 'gnused' or 'sed' in Linux.
# IF YOU WANT TO USE THIS SCRIPT ON ANOTHER SYSTEM THAN MACOS, PLEASE CHANGE ALL SED COMMANDS ACCORDINGLY.

# Declare source and destination folders:
SOURCES=/Users/$(whoami)/Music/Music/Media/Music
DESTINATION=/Users/$(whoami)/Desktop/MP3
tmp=/Users/$(whoami)/.conversion.sh

# Declare which file types you want to convert and your desired output:
INPUT="m4a"
OUTPUT="mp3"

# Declare all FFmpeg otions here (i.e. codec, bitrate settings, etc):
FFMPEG_OPTIONS="-ab 128k -map_metadata 0 -id3v2_version 3 -acodec libmp3lame -vsync 2"

# Create destination folder and copy directory tree:

mkdir $DESTINATION
cd $SOURCES
find . -type d | cpio -pdvm $DESTINATION

# CONVERT ALL *.M4A INTO *.MP3:

# Scan all folders in SOURCES for input files, and compile a list of their absolute paths:
find $SOURCES -iname *.$INPUT | sed 's:[][{}()\| ;:=!@#$%^&*",<>'"'"']:\\&:g;' >> $tmp

# Split list into input and output destinations:
sed -i '' 'h;s/^//;p;x' $tmp
sed -i '' "n;s|${SOURCES}|${DESTINATION}|g;" $tmp
sed -i '' "n;s|${INPUT}|${OUTPUT}|g;" $tmp

# Insert FFmpeg command:
sed -i '' 's/^/ffmpeg -i /;n' $tmp
sed -i '' "n;s|^|${FFMPEG_OPTIONS} |;" $tmp

# Turn list into executable shell script:
sed -i '' '$!N;s/\n/ /g' $tmp
ex -sc '1i|#!/bin/sh' -cx $tmp
chmod +x $tmp

# Convert all found files:
$tmp

# Cleanup
rm $tmp

```

### **MIRRORS**

This repository is actively maintained on Codeberg:<br>
https://codeberg.org/term7/FFmpeg-A-short-Guide

Changes are puhsed regularly to our Github Mirror:<br>
https://github.com/term7/FFmpeg-A-short-Guide
