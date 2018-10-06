#!/bin/zsh

images=(
    duckietown/rpi-ros-kinetic-base:master18
    duckietown/rpi-ros-kinetic-roscore:master18
    duckietown/rpi-duckiebot-base:master18
    duckietown/rpi-duckiebot-joystick-demo:master18
    duckietown/rpi-duckiebot-lanefollowing-demo:master18
    duckietown/rpi-duckiebot-ros-picam:master18
    duckietown/rpi-duckiebot-camera-node:master18
    duckietown/rpi-duckiebot-web_video_server:master18  )

for image in $images; do
    docker push $image
done
