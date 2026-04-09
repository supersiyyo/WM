#!/bin/bash
# Wait for the system and RTMP server to fully initialize
sleep 15

# Stream USB Camera video (/dev/video0) to the local Nginx RTMP server
# Using an infinite loop so it reconnects if the camera or server drops
while true
do
    ffmpeg -f v4l2 -input_format mjpeg -video_size 1920x1080 -framerate 30 -i /dev/video0 -c:v libx264 -preset ultrafast -tune zerolatency -pix_fmt yuv420p -threads 4 -b:v 3000k -maxrate 4000k -bufsize 8000k -g 60 -f flv rtmp://localhost/live/camera
    echo "Camera stream disconnected. Retrying in 5 seconds..."
    sleep 5
done
