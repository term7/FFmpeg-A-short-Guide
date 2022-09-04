#!/bin/bash

# Please note: This script makes use of 'sed'. In MacOS 'sed' is slightly different than 'gnused' or 'sed' in Linux.
# IF YOU WANT TO USE THIS SCRIPT ON ANOTHER SYSTEM THAN MACOS, PLEASE CHANGE ALL SED COMMANDS ACCORDINGLY.

# https://gist.github.com/term7/ff7729bd56f9d1c9718caf467c734986

# MIT License
# Copyright (c) 2021

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Declare source and destination folders:
SOURCES=/Users/$(stat -f '%Su' /dev/console)/Music/Music
DESTINATION=/Users/$(stat -f '%Su' /dev/console)/Desktop/MP3
tmp=/Users/$(stat -f '%Su' /dev/console)/.conversion.sh

# Declare which file types you want to convert and your desired output:
INPUT="m4a"
OUTPUT="mp3"

# Declare all FFmpeg otions here (i.e. codec, bitrate settings, etc):
FFMPEG_OPTIONS="-ab 128k -map_metadata 0 -id3v2_version 3 -acodec libmp3lame -vsync 2"

# Cleanup: in case something wen't wrong before...
if [ -d "$tmp" ]; then
    rm $tmp
    touch $tmp
fi

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
