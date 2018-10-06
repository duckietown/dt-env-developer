#!/bin/zsh

set -ex

t=build 

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

#make -C rpi-duckiebot-prettylights build-no-cache

# rpi-ros-kinetic-blockly-backend
# rpi-ros-kinetic-system-monitor
# rpi-duckiebot-blockly-controller
