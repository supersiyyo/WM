#!/bin/bash
# Wait for the system and RTMP server to fully initialize
sleep 15

# OPTION 1: Force CPU into Maximum Performance Mode
# This prevents the Pi from slowing down the processor when the desktop is idle
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null

# OPTION 2: Launch a Live Preview Window locally
# This runs in the background and constantly tries to show the live Nginx stream
(
    while true; do 
        sleep 5
        # Pulls the stream locally with zero buffer and shows it on-screen
        ffplay -window_title "Camera Preview" -fflags nobuffer -flags low_delay -framedrop -loglevel quiet -x 1280 -y 720 rtmp://localhost/live/camera
        sleep 2
    done
) &

# MAIN PROCESS: Stream USB Camera video to the Nginx RTMP server
while true
do
    ffmpeg -f v4l2 -input_format mjpeg -video_size 1920x1080 -framerate 30 -i /dev/video0 -c:v libx264 -preset ultrafast -tune zerolatency -pix_fmt yuv420p -threads 4 -b:v 3000k -maxrate 4000k -bufsize 8000k -g 60 -f flv rtmp://localhost/live/camera
    echo "Camera stream disconnected. Retrying in 5 seconds..."
    sleep 5
done
