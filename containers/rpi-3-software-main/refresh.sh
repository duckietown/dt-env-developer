#!/bin/zsh

set -ex

t=build-no-cache

make -C rpi-ros-kinetic-base $t

make -C rpi-ros-kinetic-roscore $t

#rpi-duckiebot-base
make -C ../../src/Software docker-$t


make -C rpi-duckiebot-camera-node $t
make -C rpi-duckiebot-joystick-demo $t
make -C rpi-duckiebot-lanefollowing-demo $t
make -C rpi-duckiebot-ros-picam $t
#make -C rpi-duckiebot-rosbridge-websocket $t
make -C rpi-duckiebot-web_video_server $t


dockviz images --tree duckietown/rpi-ros-kinetic-base:master18

echo "if you press I will also push"
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
