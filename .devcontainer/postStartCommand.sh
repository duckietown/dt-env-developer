#!/bin/bash

# Install duckietown-shell
pipx install duckietown-shell

# Create dbus directory
sudo mkdir -p /var/run/dbus

# Start dbus daemon
sudo dbus-daemon --system --fork

# Start avahi daemon
sudo avahi-daemon -D