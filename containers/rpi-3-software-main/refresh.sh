#!/usr/bin/zsh

set -e
make -C rpi-ros-kinetic-base build-no-cache

make -C rpi-ros-kinetic-roscore build-no-cache

#rpi-duckiebot-base
make -C ../src/Software docker-build-no-cache


make -C rpi-duckiebot-camera-node  build-no-cache
make -C rpi-duckiebot-joystick-demo build-no-cache
make -C rpi-duckiebot-lanefollowing-demo build-no-cache
make -C rpi-duckiebot-ros-picam build-no-cache
make -C rpi-duckiebot-rosbridge-websocket build-no-cache
make -C rpi-duckiebot-web_video_server build-no-cache


dockviz images --tree duckietown/rpi-ros-kinetic-base:master18

echo "wait"
read

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

#make -C rpi-duckiebot-prettylights build-no-cache

# rpi-ros-kinetic-blockly-backend
# rpi-ros-kinetic-system-monitor
# rpi-duckiebot-blockly-controller
