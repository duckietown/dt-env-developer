#!/bin/zsh

set -ex

for a in */rpi*; do
    cp labels.py $a/labels.py
    chmod +x $a/labels.py
    cp Makefile.in $a/Makefile
done
