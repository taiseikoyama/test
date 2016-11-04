#!/bin/bash
recording_time=$1
dir=$2
dir="${dir%/}"
stop="stop"
if [ 2 != $# ]; then
    echo "Usage: $0 recording_time directory"
    echo " recording_time: The number of seconds you want to video recording (Required)"
    echo " directory: Directory where you want to save your video (Requird)"
    echo "Example"
    echo " ./recording 60 /home/pi/vidoes"
    exit 1
fi

if [ ! -e $dir ] || [ ! -d $dir ]; then
    echo "Directory does not exist"
    exit 1
fi

expect_empty=`echo -n $1 | sed 's/[0-9]//g'`
if [ "x" = "x$1" ] || [ "x" != "x${expect_empty}" ] || [ $recording_time -le 0 ]; then
    echo "Please enter a numeric value in the natural number"
    exit 1
fi

while :
do
    videos=($(ls -1 /dev/video*))
    for video_dev in "${videos[@]}"
    do
        now_time=($(date "+%Y-%m-%d_%H:%M:%S"))
        video_name="${video_dev##*/}"
        recording="timeout --signal=SIGINT $recording_time gst-launch-1.0 -e v4l2src device=$video_dev do-timestamp=true ! video/x-raw,format=I420,framerate=30/1,width=640,height=480 ! videorate ! clockoverlay  halignment=right valignment=bottom time-format='%Y-%m-%d_%H:%M:%S' !  omxh264enc control-rate=variable target-bitrate=512000 ! video/x-h264,profile=main ! h264parse  ! qtmux! filesink location=$dir/$video_name-$now_time.mp4"

        if [ ! -e $video_dev ]; then
          continue
        fi

        if [ -e $stop ]; then
          echo "Recording stopped due to stop file"
          exit 0
        fi
        eval ${recording}
    done
done

exi t 0



