#!/bin/bash

# Install duckietown-shell
pipx install duckietown-shell
direnv allow /workspaces/dt-env-developer/.envrc

# Create dbus directory
sudo mkdir -p /var/run/dbus

# Start dbus daemon
sudo dbus-daemon --system --fork

# Start avahi daemon
sudo avahi-daemon -D